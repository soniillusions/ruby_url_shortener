module Bot::Commands
  class UnknownCommand < BaseCommand
    def call
      bot.api.send_message(
        chat_id: message.chat.id,
        text: '⚠️ Invalid link. Please try again.'
      )
    end
  end
end