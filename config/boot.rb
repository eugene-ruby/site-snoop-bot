require 'dotenv/load'
require_relative '../db/setup'
require 'zeitwerk'

loader = Zeitwerk::Loader.new
loader.push_dir("#{__dir__}/../lib", namespace: Object)
loader.push_dir("#{__dir__}/../models", namespace: Object)
loader.push_dir("#{__dir__}/../lib/services", namespace: Object)
loader.setup
require 'sidekiq'
require 'sidekiq/cron/job'

# Настройка задачи для sidekiq-cron
schedule = {
  'CheckAllSnapshots' => {
    'class' => 'SnapshotCheckAllWorker',
    'cron' => '*/10 * * * *',
    'description' => 'Check all snapshots every 10 minutes'
  }
}

Sidekiq::Cron::Job.load_from_hash(schedule)

loader.eager_load
