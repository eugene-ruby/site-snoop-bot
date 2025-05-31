require 'logger'

module Bot
  module Logger
    INFO = 'INFO'.freeze
    def self.logger
      @logger ||= ::Logger.new($stdout).tap do |log|
        log.level = Logger::INFO
        log.progname = 'SiteSnoopBot'
      end
    end
  end
end
