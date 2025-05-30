module Bot
  module Commands
    class StartCommand
      def self.call(bot:, message:)
        bot.api.send_message(chat_id: message.chat.id, text: "Welcome to SiteSnoopBot!")
      end
    end
  end
end
