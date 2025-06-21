module Bot::Commands
  class MyLinksCommand < BaseCommand
    def call
      links = user.links

      if links.empty?
        bot.api.send_message(
          chat_id: message.chat.id,
          text: "Пока ничего нет. Сначала сократите ссылку.",
          reply_markup: keyboard
        )
        return
      end

      links.each_with_index do |link, index|
        text = "#{index + 1}. #{BASE_URL}/#{link.short_url} → #{link.original_url}"

        bot.api.send_message(
          chat_id: chat_id,
          text: text,
          reply_markup: delete_button_markup(link.id),
          disable_web_page_preview: true
        )
      end

      bot.api.send_message(
        chat_id: chat_id,
        text: "Выберите дальнейшее действие:",
        reply_markup: Telegram::Bot::Types::InlineKeyboardMarkup.new(
          inline_keyboard: [
            [
              Telegram::Bot::Types::InlineKeyboardButton.new(text: "➕ Новая ссылка", callback_data: "start_over"),
              Telegram::Bot::Types::InlineKeyboardButton.new(text: "🏠 Главное меню", callback_data: "main_menu")
            ]
          ]
        )
      )
    end

    private

    def delete_button_markup(link_id)
      Telegram::Bot::Types::InlineKeyboardMarkup.new(
        inline_keyboard: [
          [
            Telegram::Bot::Types::InlineKeyboardButton.new(
              text: "🗑 Удалить",
              callback_data: "delete:#{link_id}"
            )
          ]
        ]
      )
    end
  end
end
