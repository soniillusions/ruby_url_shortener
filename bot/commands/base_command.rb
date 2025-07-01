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
        @user ||= User.where(telegram_id: message.from.id.to_s).first ||
                  User.create(telegram_id: message.from.id.to_s)
      end

      def chat_id
        message.chat.id
      end

      def keyboard
        @keyboard ||= Telegram::Bot::Types::ReplyKeyboardMarkup.new(
          keyboard: [
            [ Telegram::Bot::Types::KeyboardButton.new(text: 'Shorten a link') ],
            [ Telegram::Bot::Types::KeyboardButton.new(text: 'My links')      ]
          ],
          resize_keyboard: true,
          one_time_keyboard: false
        )
      end

      def inline_keyboard
        Telegram::Bot::Types::InlineKeyboardMarkup.new(
          inline_keyboard: [
            [Telegram::Bot::Types::InlineKeyboardButton.new(text: '🏠 Main menu', callback_data: 'main_menu')]
          ]
        )
      end
    end
  end
end
