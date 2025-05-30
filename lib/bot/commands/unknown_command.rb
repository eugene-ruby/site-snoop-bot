module Bot
  module Commands
    class UnknownCommand
      def self.call(bot:, message:)
        bot.api.send_message(chat_id: message.chat.id, text: "Неверный формат. Используйте /watch <url> <css_selector>")
      end
    end
  end
end
