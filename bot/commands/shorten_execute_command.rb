module Bot::Commands
  class ShortenExecuteCommand < BaseCommand
    URL_REGEX = /\A(\S+\.\S+)\z/i

    def call
      original_url = message.text.match(URL_REGEX)[1]
      link = Shortener.new(user, original_url).find_or_create_for_user

      bot.api.send_message(
        chat_id: message.chat.id,
        text: "Your short link:\n🔗 #{BASE_URL}#{link.short_url}",
        disable_web_page_preview: true,
        reply_markup: inline_keyboard_for_link(link)
      )
      bot.api.send_message(
        chat_id: message.chat.id,
        text: "Choose an action:",
        reply_markup: keyboard
      )
    rescue ArgumentError => e
      bot.api.send_message(chat_id: message.chat.id, text: "Error: #{e.message}", reply_markup: default_keyboard)
    end

    private
    
    def inline_keyboard_for_link(link)
      Telegram::Bot::Types::InlineKeyboardMarkup.new(
        inline_keyboard: [
          [
            Telegram::Bot::Types::InlineKeyboardButton.new(
              text: '🗑 Delete',
              callback_data: "delete:#{link.id}"
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