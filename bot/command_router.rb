module Bot
  class CommandRouter
    def initialize(bot, message)
      @bot, @message = bot, message
    end

    def route
      case @message
      when Telegram::Bot::Types::Message
        route_message
      when Telegram::Bot::Types::CallbackQuery
        route_callback_query
      when Telegram::Bot::Types::ChatMemberUpdated
        handle_chat_member_update
      else
        puts "Unknown message type: #{@message.class}"
      end
    end

    private

    attr_reader :bot, :message

    def route_message
      return unless message.text

      case message.text
      when %r{^/start}        then Commands::StartCommand.new(bot, message)
      when 'Сократить ссылку' then Commands::ShortenRequestCommand.new(bot, message)
      when /\A(\S+\.\S+)\z/   then Commands::ShortenExecuteCommand.new(bot, message)
      when 'Мои ссылки'       then Commands::MyLinksCommand.new(bot, message)
      else                         Commands::UnknownCommand.new(bot, message)
      end.call
    end

    def route_callback_query
      case message.data
      when /^delete:(\d+)$/
        Commands::DeleteLinkCommand.new(bot, message).call
      when 'start_over'
        Commands::ShortenRequestCommand.new(bot, message).call
      when 'main_menu'
        bot.api.send_message(
          chat_id: callback_query.message.chat.id,
          text: "Главное меню:",
          reply_markup: default_keyboard
        )
      else
        bot.api.answer_callback_query(callback_query_id: message.id, text: "Неизвестное действие")
      end
    end

    def handle_chat_member_update
      if message.new_chat_member.status == 'kicked'
        puts "Bot was blocked by user #{message.from.id}"
      elsif message.new_chat_member.status == 'member'
        puts "Bot was added to chat by user #{message.from.id}"
      end
    end
  end
end