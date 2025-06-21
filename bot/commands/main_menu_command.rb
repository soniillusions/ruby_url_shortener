module Bot::Commands
  class MainMenuCommand < BaseCommand
    def call
      bot.api.send_message(
        chat_id: chat_id,
        text: 'Главное меню:',
        reply_markup: keyboard
      )
    end
  end
end