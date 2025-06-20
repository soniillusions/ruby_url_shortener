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
    case message.text
    when '/start', '/start start'
      bot.api.send_message(
        chat_id: message.chat.id,
        text: "Hello, #{message.from.first_name}! With this bot, you can quickly and easily shorten your long URLs."
      )
    when %r{^/shorten\s+(.+)}i
      original_url = Regexp.last_match(1).strip
      user = User.find_or_create(telegram_id: message.from.id.to_s)

      begin
        link = Shortener.new(user, original_url).find_or_create_for_user
        bot.api.send_message(
          chat_id: message.chat.id,
          text: "Your short URL: #{BASE_URL}/#{link.short_url}"
        )
      rescue ArgumentError => e
        bot.api.send_message(chat_id: message.chat.id, text: "Error: #{e.message}")
      end
    end
  end
end