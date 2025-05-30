module Bot
  module Commands
    class ListCommand
      def self.call(bot:, message:)
        chat_id = message.chat.id
        snapshots = Snapshot.where(chat_id: chat_id)

        if snapshots.empty?
          bot.api.send_message(chat_id: chat_id, text: "Вы пока ни за чем не наблюдаете.")
        else
          response = snapshots.map { |s| "URL: #{s.url}, Attribute Query: #{s.attribute_query}" }.join("\n")
          bot.api.send_message(chat_id: chat_id, text: response)
        end
      end
    end
  end
end
