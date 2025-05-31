module Bot
  module Commands
    class ScreenCommand
      def self.call(bot:, message:)
        url = message.text.split(' ')[1]
        chat_id = message.chat.id

        if url.nil?
          bot.api.send_message(chat_id: chat_id, text: "Пожалуйста, укажите URL для создания скриншота.")
          return
        end

        screenshot = Screenshot::Screenshot.new(url)
        file_path = screenshot.capture

        if File.exist?(file_path)
          bot.api.send_photo(chat_id: chat_id, photo: Faraday::UploadIO.new(file_path, 'image/png'))
        else
          bot.api.send_message(chat_id: chat_id, text: "Не удалось создать скриншот для указанного URL.")
        end
      end
    end
  end
end
