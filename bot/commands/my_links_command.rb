module Bot::Commands
  class MyLinksCommand < BaseCommand
    def call
      links = user.links
      text  = if links.empty?
                "Пока ничего нет. Сначала сократите ссылку."
              else
                links.each_with_index.map {|l,i|
                  "#{i+1}. #{BASE_URL}/#{l.short_url} → #{l.original_url}"
                }.join("\n\n")
              end

      bot.api.send_message(
        chat_id: chat_id,
        text: text,
        reply_markup: keyboard,
        disable_web_page_preview: true
      )
    end
  end
end
