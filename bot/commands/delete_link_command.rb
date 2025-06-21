module Bot::Commands
  class DeleteLinkCommand < BaseCommand
    def call
      link_id = message.data.match(/^delete:(\d+)$/)[1].to_i
      user_link = UserLink.where(user_id: user.id, link_id: link_id).first

      if user_link
        user_link.destroy

        bot.api.answer_callback_query(callback_query_id: message.id)

        bot.api.edit_message_text(
          chat_id: message.message.chat.id,
          message_id: message.message.message_id,
          text: "Ссылка удалена ✅"
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