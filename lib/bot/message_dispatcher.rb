module Bot
  class MessageDispatcher
    def self.call(bot, message)
      case message.text
      when '/start'
        Commands::StartCommand.call(bot: bot, message: message)
      when /^\/watch\s+(\S+)\s+(.+)$/
        Commands::WatchCommand.call(bot: bot, message: message)
      when '/list'
        Commands::ListCommand.call(bot: bot, message: message)
      when /^\/del\s+(\d+)$/
        Commands::DeleteCommand.call(bot: bot, message: message)
      else
        Commands::UnknownCommand.call(bot: bot, message: message)
      end
    end
  end
end
