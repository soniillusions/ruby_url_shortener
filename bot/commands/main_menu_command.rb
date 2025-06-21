module Bot::Commands
  class MainMenuCommand < BaseCommand
    def call
      bot.api.answer_callback_query(callback_query_id: message.id)
      
      bot.api.send_message(
        chat_id: message.message.chat.id,
        text: 'Главное меню:',
        reply_markup: keyboard
      )
    end
  end
end