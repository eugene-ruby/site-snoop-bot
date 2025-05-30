require_relative 'config/boot'

namespace :bot do
  desc "Start the Telegram bot"
  task :listen do
    Bot::SiteSnoopBot.run
  end
end

namespace :snapshots do
  desc "Check all snapshots"
  task :check_all do
    require_relative 'lib/services/snapshot_check_all_worker'
    SnapshotCheckAllWorker.perform_async
  end
end
