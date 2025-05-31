module Bot
  module Commands
    class WatchCommand
      def self.call(bot:, message:)
        url, attribute_query = message.text.match(/^\/watch\s+(\S+)\s+(.+)$/).captures
        chat_id = message.chat.id
        result = WatchTaskCreator.call(url: url, selector: attribute_query, chat_id: chat_id)

        if result.success?
          bot.api.send_message(chat_id: message.chat.id, text: "Теперь слежу за #{url} с атрибутом #{attribute_query}.")
        else
          case result.failure
          when :exists
            bot.api.send_message(chat_id: message.chat.id, text: "Я уже наблюдаю за этим элементом.")
          when :limit_exceeded
            bot.api.send_message(chat_id: message.chat.id, text: "Вы добавили слишком много отслеживаемых элементов. Доступно не более #{MAX_SNAPSHOTS_PER_CHAT}.")
          else
            SiteSnoopBot.logger.error("Watch creation error: #{result.failure.inspect}")
            bot.api.send_message(chat_id: message.chat.id, text: "Не удалось установить наблюдение. Попробуйте позже.")
          end
        end
      end
    end
  end
end
