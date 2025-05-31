require 'spec_helper'
require 'webrick'
require 'timeout'

RSpec.describe CheckTaskWorker do
  include FactoryBot::Syntax::Methods
  let(:text) { 'some text!' }
  let(:snapshot) do
    create(:snapshot, url: 'http://localhost:4567/', last_checked_at: nil, attribute_query: 'data-qa="title"')
  end

  before(:all) do
    @server_thread = Thread.new do
      root = ->(_req, res) {
        res['Content-Type'] = 'text/html'
        res.body = "<div data-qa=\"title\">#{text}</div>"
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

  before do
    allow(Notifier).to receive(:call)
  end

  it 'извлекает текст по data-qa атрибуту и обновляет snapshot' do
    expect(snapshot.last_checked_at).to be_nil

    CheckTaskWorker.new.perform(snapshot.id)
    snapshot.refresh

    expect(snapshot.last_checked_at).not_to be_nil
    expect(snapshot.content_hash).to eq Digest::SHA256.hexdigest(text).encode('UTF-8')

    expect(Notifier).to have_received(:call).with(chat_id: snapshot.chat_id, message: "Контент изменился. Новое содержимое:\n#{text}")
  end
end
