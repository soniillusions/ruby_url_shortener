module Bot
  module Commands
    class BaseCommand
      attr_reader :bot, :message

      def initialize(bot, message)
        @bot, @message = bot, message
      end

      def call
        raise NotImplementedError
      end

      private

      def user
        @user ||= User.find_or_create(telegram_id: message.from.id.to_s)
      end

      def chat_id
        message.chat.id
      end

      def user
        @user ||= User.find_or_create(telegram_id: message.from.id.to_s)
      end

      def keyboard
        @keyboard ||= Telegram::Bot::Types::ReplyKeyboardMarkup.new(
          keyboard: [
            [ Telegram::Bot::Types::KeyboardButton.new(text: 'Сократить ссылку') ],
            [ Telegram::Bot::Types::KeyboardButton.new(text: 'Мои ссылки')      ]
          ],
          resize_keyboard: true,
          one_time_keyboard: false
        )
      end
    end
  end
end
