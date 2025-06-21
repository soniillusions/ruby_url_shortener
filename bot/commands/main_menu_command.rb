module Bot::Commands
  class MainMenuCommand < BaseCommand
    def call
      if message.is_a?(Telegram::Bot::Types::CallbackQuery)
        bot.api.answer_callback_query(callback_query_id: message.id)
        
        chat_id = message.message.chat.id

        begin
          bot.api.delete_message(
            chat_id: chat_id,
            message_id: message.message.message_id
          )
        rescue Telegram::Bot::Exceptions::ResponseError => e
          puts "Не удалось удалить сообщение: #{e.message}"
        end
      else
        chat_id = message.chat.id
      end
      
      bot.api.send_message(
        chat_id: chat_id,
        text: 'Главное меню:',
        reply_markup: keyboard
      )
    end
  end
end