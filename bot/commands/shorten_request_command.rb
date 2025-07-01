module Bot::Commands
  class ShortenRequestCommand < BaseCommand
    def call
      if message.is_a?(Telegram::Bot::Types::CallbackQuery)
        bot.api.answer_callback_query(callback_query_id: message.id)
      end

      bot.api.send_message(
        chat_id: chat_id,
        text: 'Send me a link to shorten.',
        reply_markup: Telegram::Bot::Types::ReplyKeyboardRemove.new(remove_keyboard: true)
      )
    end

    def chat_id
      if message.is_a?(Telegram::Bot::Types::CallbackQuery)
        message.message.chat.id
      else
        message.chat.id
      end
    end
  end
end