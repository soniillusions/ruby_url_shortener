module Bot::Commands
  class StartCommand < BaseCommand
    def call
      bot.api.send_message(
        chat_id: chat_id,
        text: "Выберите действие:",
        reply_markup: keyboard
      )
    end
  end
end