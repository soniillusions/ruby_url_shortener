module Bot::Commands
  class UnknownCommand < BaseCommand
    def call
      bot.api.send_message(chat_id: message.chat.id, text: '⚠️ Невалидная ссылка. Попробуйте ещё раз.')
    end
  end
end