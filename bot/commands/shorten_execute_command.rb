module Bot::Commands
  class ShortenExecuteCommand < BaseCommand
    URL_REGEX = /\A(\S+\.\S+)\z/i

    def call
      original_url = message.text.match(URL_REGEX)[1]
      link = Shortener.new(user, original_url).find_or_create_for_user

      bot.api.send_message(
        chat_id: message.chat.id,
        text: "Your short URL: #{BASE_URL}/#{link.short_url}",
        reply_markup: keyboard
      )
    rescue ArgumentError => e
      bot.api.send_message(chat_id: message.chat.id, text: "Error: #{e.message}", reply_markup: keyboard)
    end
  end
end