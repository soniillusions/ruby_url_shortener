module Bot
  class CommandRouter
    def initialize(bot, message)
      @bot, @message = bot, message
    end

    def route
      case message.text
      when %r{^/start}        then Commands::StartCommand.new(bot, message)
      when 'Сократить ссылку' then Commands::ShortenRequestCommand.new(bot, message)
      when /\A(\S+\.\S+)\z/   then Commands::ShortenExecuteCommand.new(bot, message)
      when 'Мои ссылки'       then Commands::MyLinksCommand.new(bot, message)
      else                         Commands::UnknownCommand.new(bot, message)
      end.call
    end

    private
    attr_reader :bot, :message
  end
end
