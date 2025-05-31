module Bot
  module Commands
    class ListCommand
      def self.call(bot:, message:)
        chat_id = message.chat.id
        snapshots = Snapshot.where(chat_id: chat_id)

        if snapshots.empty?
          bot.api.send_message(chat_id: chat_id, text: "Вы пока ни за чем не наблюдаете.")
        else
          response = snapshots.map do |s|
            "ID: #{s.id}, URL: #{s.url}, Attribute Query: #{s.attribute_query}, Last Checked At: #{s.last_checked_at.strftime('%Y-%m-%d %H:%M:%S')}"
          end
          bot.api.send_message(chat_id: chat_id, text: response.join("\n"))
        end
      end
    end
  end
end
