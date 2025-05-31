require 'sidekiq'
class SnapshotCheckAllWorker
  include Sidekiq::Worker

  def perform
    Snapshot.each do |snapshot|
      CheckTaskWorker.perform_async(snapshot.id)
    end
  end
end
