module Bot
  class CommandRouter
    def initialize(bot, message)
      @bot, @message = bot, message
    end

    def route
      if message.is_a?(Telegram::Bot::Types::CallbackQuery)
        route_callback_query
      else
        route_message
      end
    end

    private

    attr_reader :bot, :message

    def route_message
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
        Commands::MainMenuCommand.new(bot, message).call
      else
        bot.api.answer_callback_query(callback_query_id: message.id, text: "Неизвестное действие")
      end
    end
  end
end
