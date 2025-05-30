require 'spec_helper'
require 'bot/message_dispatcher'

RSpec.describe Bot::MessageDispatcher do
  let(:bot) { double('bot') }
  let(:message) { double('message', text: text) }

  describe '.call' do
    context 'when message is /start' do
      let(:text) { '/start' }

      it 'delegates to StartCommand' do
        expect(Bot::Commands::StartCommand).to receive(:call).with(bot: bot, message: message)
        described_class.call(bot, message)
      end
    end

    context 'when message is /watch' do
      let(:text) { '/watch http://example.com .price' }

      it 'delegates to WatchCommand' do
        expect(Bot::Commands::WatchCommand).to receive(:call).with(bot: bot, message: message)
        described_class.call(bot, message)
      end
    end

    context 'when message is unknown' do
      let(:text) { '/unknown' }

      it 'delegates to UnknownCommand' do
        expect(Bot::Commands::UnknownCommand).to receive(:call).with(bot: bot, message: message)
        described_class.call(bot, message)
      end
    end
  end
end
