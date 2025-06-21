module Bot::Commands
  class ShortenRequestCommand < BaseCommand
    def call
      bot.api.send_message(
        chat_id: message.chat.id,
        text: 'Отправьте мне ссылку для сокращения.',
        reply_markup: Telegram::Bot::Types::ReplyKeyboardRemove.new(remove_keyboard: true)
      )
    end
  end
end