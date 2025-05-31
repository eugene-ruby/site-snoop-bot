require 'spec_helper'

RSpec.describe Bot::MessageDispatcher do
  let(:bot) { double('bot', api: double('api', send_message: nil)) }
  let(:chat_id) { 123 }
  let(:message_start) { double('message', text: '/start', chat: double('chat', id: chat_id)) }
  let(:message_watch) { double('message', text: '/watch example.com attribute', chat: double('chat', id: chat_id)) }
  let(:message_list) { double('message', text: '/list', chat: double('chat', id: chat_id)) }
  let(:message_del) { double('message', text: '/del 1', chat: double('chat', id: chat_id)) }
  let(:message_unknown) { double('message', text: '/unknownFake', chat: double('chat', id: chat_id)) }

  describe '.call' do
    it 'calls StartCommand for /start message' do
      expect(Bot::Commands::StartCommand).to receive(:call).with(bot: bot, message: message_start)
      described_class.call(bot, message_start)
    end

    it 'calls WatchCommand for /watch message' do
      expect(Bot::Commands::WatchCommand).to receive(:call).with(bot: bot, message: message_watch)
      described_class.call(bot, message_watch)
    end

    it 'calls ListCommand for /list message' do
      expect(Bot::Commands::ListCommand).to receive(:call).with(bot: bot, message: message_list)
      described_class.call(bot, message_list)
    end

    it 'calls DeleteCommand for /del message' do
      expect(Bot::Commands::DeleteCommand).to receive(:call).with(bot: bot, message: message_del)
      described_class.call(bot, message_del)
    end
  end

  context 'when message is unknown' do
    it 'delegates to UnknownCommand' do
      expect(Bot::Commands::UnknownCommand).to receive(:call).with(bot: bot, message: message_unknown)
      described_class.call(bot, message_unknown)
    end
  end
end
