module Bot::Commands
  class ShortenExecuteCommand < BaseCommand
    URL_REGEX = /\A(\S+\.\S+)\z/i

    def call
      original_url = message.text.match(URL_REGEX)[1]
      link = Shortener.new(user, original_url).find_or_create_for_user

      bot.api.send_message(
        chat_id: message.chat.id,
        text: "Ваша короткая ссылка:\n🔗 #{BASE_URL}/#{link.short_url}",
        reply_markup: keyboard(link)
      )
    rescue ArgumentError => e
      bot.api.send_message(chat_id: message.chat.id, text: "Error: #{e.message}", reply_markup: default_keyboard)
    end

    private
    def keyboard(link)
      Telegram::Bot::Types::InlineKeyboardMarkup.new(
        inline_keyboard: [
          [
            Telegram::Bot::Types::InlineKeyboardButton.new(
              text: '🗑 Удалить',
              callback_data: "delete:#{link.id}"
            ),
            Telegram::Bot::Types::InlineKeyboardButton.new(
              text: '🔁 Новая ссылка',
              callback_data: 'start_over'
            )
          ]
        ]
      )
    end

    def default_keyboard
      Telegram::Bot::Types::ReplyKeyboardRemove.new(remove_keyboard: true)
    end
  end
end