require_relative '../config/boot'
require 'telegram/bot'

module Bot
  class SiteSnoopBot
    TELEGRAM_BOT_TOKEN = ENV.fetch('TELEGRAM_BOT_TOKEN').freeze
    def self.logger
    @logger ||= Logger.new($stdout)
    end


    def self.run
    Telegram::Bot::Client.run(TELEGRAM_BOT_TOKEN) do |bot|
      bot.listen do |message|
        Bot::MessageDispatcher.call(bot, message)
      end
    end
  end
  end
end
