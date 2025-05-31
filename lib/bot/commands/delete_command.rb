module Bot
  module Commands
    class DeleteCommand
      def self.call(bot:, message:)
        snapshot_id = message.text.match(/^\/del\s+(\d+)$/).captures.first.to_i
        snapshot = Snapshot[chat_id: message.chat.id, id: snapshot_id]

        if snapshot
          snapshot.delete
          Bot::Logger.instance.info("Снимок с ID #{snapshot_id} удален.")
          bot.api.send_message(chat_id: message.chat.id, text: "Снимок с ID #{snapshot_id} удален.")
        else
          Bot::Logger.instance.info("Снимок с ID #{snapshot_id} не найден.")
          bot.api.send_message(chat_id: message.chat.id, text: "Снимок с ID #{snapshot_id} не найден.")
        end
      end
    end
  end
end
