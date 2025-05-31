require 'spec_helper'

RSpec.describe Bot::Commands::ListCommand do
  let(:bot) { double('bot', api: api) }
  let(:api) { double('api') }
  let(:message) { double('message', chat: double('chat', id: 1)) }

  describe '.call' do
    context 'when there are snapshots' do
      before do
        allow(Snapshot).to receive(:where).with(chat_id: 1).and_return([double('snapshot', id: 11, url: 'http://example.com', attribute_query: 'data-qa=title')])
      end

      it 'sends a list of snapshots' do
        expect(api).to receive(:send_message).with(chat_id: 1, text: "ID: 11, URL: http://example.com, Attribute Query: data-qa=title")
        described_class.call(bot: bot, message: message)
      end
    end

    context 'when there are no snapshots' do
      before do
        allow(Snapshot).to receive(:where).with(chat_id: 1).and_return([])
      end

      it 'sends a no snapshots message' do
        expect(api).to receive(:send_message).with(chat_id: 1, text: "Вы пока ни за чем не наблюдаете.")
        described_class.call(bot: bot, message: message)
      end
    end
  end
end
