require 'telegram/bot'
require 'sequel'
require 'dotenv'
Dotenv.load

TOKEN = ENV['TOKEN']

Telegram::Bot::Client.run(TOKEN) do |bot|
  bot.listen do |message|
    case message.text
    when '/start', '/start start'
      bot.api.send_message(
        chat_id: message.chat.id,
        text: "Hello, #{message.from.first_name}! With this bot, you can quickly and easily shorten your long URLs."
      )
    end
  end
end