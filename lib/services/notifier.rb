require 'telegram/bot'

class Notifier
  TELEGRAM_BOT_TOKEN = ENV.fetch('TELEGRAM_BOT_TOKEN').freeze

  def self.call(chat_id:, message:)
    Telegram::Bot::Client.run(TELEGRAM_BOT_TOKEN) do |bot|
      bot.api.send_message(chat_id: chat_id, text: message)
    end
  end
end
