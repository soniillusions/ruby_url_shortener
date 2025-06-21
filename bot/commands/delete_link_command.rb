module Bot::Commands
  class DeleteLink < BaseCommand
    def call
      link_id = message.data.match(/^delete:(\d+)$/)[1].to_i
      user_link = UserLink.find_by(user: user, link_id: link_id)

      if user_link
        user_link.destroy

        bot.api.edit_message_text(
          chat_id: message.from.id,
          message_id: message.message.message_id,
          text: "🗑 Ссылка отвязана от вашего аккаунта"
        )
      else
        bot.api.answer_callback_query(
          callback_query_id: message.id,
          text: "Ссылка не найдена или уже удалена"
        )
      end
    end
  end
end