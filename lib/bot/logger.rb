require 'logger'

module Bot
  module Logger
    def self.instance
      @logger ||= ::Logger.new($stdout).tap do |log|
        log.level = Logger::INFO
        log.progname = 'SiteSnoopBot'
      end
    end
  end
end
