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
      when 'Shorten a link' then Commands::ShortenRequestCommand.new(bot, message)
      when /\A(\S+\.\S+)\z/   then Commands::ShortenExecuteCommand.new(bot, message)
      when 'My links'       then Commands::MyLinksCommand.new(bot, message)
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
        Commands::MainMenuCommand.new(bot, message).call
      else
        bot.api.answer_callback_query(callback_query_id: message.id, text: "Unknown action")
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