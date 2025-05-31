require 'spec_helper'
require 'webrick'
require 'timeout'

RSpec.describe CheckTaskWorker do
  include FactoryBot::Syntax::Methods

  before(:all) do
    @server_thread = Thread.new do
      root = ->(_req, res) {
        res['Content-Type'] = 'text/html'
        res.body = '<div data-qa="title">Привет, мир!</div>'
      }

      @server = WEBrick::HTTPServer.new(
        Port: 4567,
        Logger: WEBrick::Log.new('/dev/null'),
        AccessLog: [],
        StartCallback: proc { @started = true }
      )
      @server.mount_proc('/', root)
      @server.start
    end

    Timeout.timeout(5) { sleep 0.1 until @started }
  end

  after(:all) do
    @server.shutdown
    @server_thread.join
  end

  it 'извлекает текст по data-qa атрибуту и обновляет snapshot' do
    snapshot = create(:snapshot, url: 'http://localhost:4567/', attribute_query: 'data-qa="title"')
    # expect(snapshot.last_checked_at).to be_nil

    CheckTaskWorker.new.perform(snapshot.id)
    snapshot.refresh

    expect(snapshot.last_checked_at).not_to be_nil
    expect(snapshot.content_hash).to eq Digest::SHA256.hexdigest('Привет, мир!')
  end
end
