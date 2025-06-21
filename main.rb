require 'telegram/bot'
require 'sequel'
require 'dotenv/load'
require 'yaml'
require 'erb'

ENV['RACK_ENV'] ||= 'development'
config_path = File.expand_path('config/database.yml', __dir__)
raw_config = ERB.new(File.read(config_path)).result
configs  = YAML.safe_load(raw_config, aliases: true)
db_conf = configs.fetch(ENV['RACK_ENV'])

DB = Sequel.connect(db_conf)

Sequel.extension :migration
Sequel::Migrator.run(DB, File.expand_path('db/migrate', __dir__))

Dir[File.expand_path('models/*.rb', __dir__)].sort.each { |f| require f }
Dir[File.expand_path('services/*.rb', __dir__)].sort.each { |f| require f }

TOKEN = ENV.fetch('TOKEN')
BASE_URL = ENV.fetch('BASE_URL', 'http://127.0.0.1:4567')

Telegram::Bot::Client.run(TOKEN) do |bot|
  bot.listen do |message|
    keyboard = Telegram::Bot::Types::ReplyKeyboardMarkup.new(
      keyboard: [
        [ Telegram::Bot::Types::KeyboardButton.new(text: 'Сократить ссылку') ],
        [ Telegram::Bot::Types::KeyboardButton.new(text: 'Мои ссылки') ]
      ],
      resize_keyboard: true, 
      one_time_keyboard: true
    )

    case message.text
    when '/start', '/start start'
      bot.api.send_message(
        chat_id: message.chat.id,
        text: "Выберите действие:",
        reply_markup: keyboard
      )
    when 'Сократить ссылку'
      bot.api.send_message(
        chat_id: message.chat.id,
        text: "Отправьте мне ссылку для сокращения.",
        reply_markup: Telegram::Bot::Types::ReplyKeyboardRemove.new(remove_keyboard: true)
      )
    when 'Мои ссылки'
      bot.api.send_message(
        chat_id: message.chat.id,
        text: "Ваши ссылки:",
        reply_markup: Telegram::Bot::Types::ReplyKeyboardRemove.new(remove_keyboard: true)
      )

      user = User.first(telegram_id: message.from.id.to_s)
      links = user ? user.links : []

      if links.empty?
        bot.api.send_message(
          chat_id: message.chat.id,
          text: "Пока ничего нет. Сначала сократите ссылку.",
          reply_markup: keyboard
        )
      else
        text = links.each_with_index.map do |l, i|
          "#{i + 1}. #{BASE_URL}/#{l.short_url}\n   ↳ #{l.original_url}"
        end.join("\n\n")
        bot.api.send_message(
          chat_id: message.chat.id,
          text: text,
          disable_web_page_preview: true,
          reply_markup: keyboard
        )
      end
    when %r{\A(?:https?://)?\S+\.\S+\z}i
      original_url = message.text
      original_url = "http://#{original_url}" unless original_url =~ %r{\Ahttps?://}i

      user = User.find_or_create(telegram_id: message.from.id.to_s)

      begin
        link = Shortener.new(user, original_url).find_or_create_for_user
        bot.api.send_message(
          chat_id: message.chat.id,
          text: "Your short URL: #{BASE_URL}/#{link.short_url}",
          reply_markup: keyboard
        )
      rescue ArgumentError => e
        bot.api.send_message(chat_id: message.chat.id, text: "Error: #{e.message}", reply_markup: markup)
      end
    end
  end
end