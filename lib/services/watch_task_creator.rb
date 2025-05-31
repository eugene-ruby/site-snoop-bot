require 'dry/monads'

class WatchTaskCreator
  include Dry::Monads[:result]

  def self.call(url:, selector:, chat_id:)
    new(url, selector, chat_id).call
  end

  def initialize(url, selector, chat_id)
    @url = url
    @selector = selector
    @chat_id = chat_id
  end

  def call
    return Failure(:limit_exceeded) if Snapshot.where(chat_id: @chat_id).count >= 10

    snapshot = Snapshot.where(url: @url, attribute_query: @selector).first

    if snapshot
      Failure(:exists)
    else
      Snapshot.create(url: @url, attribute_query: @selector, content_hash: '', last_checked_at: Time.now, chat_id: @chat_id)
      Success(:created)
    end
  end
end
