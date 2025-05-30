require 'spec_helper'
require 'bot/commands/watch_command'

RSpec.describe Bot::Commands::WatchCommand do
  let(:bot) { double('bot', api: api) }
  let(:api) { double('api') }
  let(:message) { double('message', text: '/watch http://example.com data-qa=title', chat: double('chat', id: 1)) }

  describe '.call' do
    context 'when watch task is created' do
      before do
        allow(WatchTaskCreator).to receive(:call).with(url: 'http://example.com', selector: 'data-qa=title', chat_id: 1).and_return(Dry::Monads::Success(:created))
      end

      it 'sends a success message' do
        expect(api).to receive(:send_message).with(chat_id: message.chat.id, text: "Теперь слежу за http://example.com с атрибутом data-qa=title.")
        described_class.call(bot: bot, message: message)
      end
    end

    context 'when watch task already exists' do
      before do
        allow(WatchTaskCreator).to receive(:call).with(url: 'http://example.com', selector: 'data-qa=title', chat_id: 1).and_return(Dry::Monads::Failure(:exists))
      end

      it 'sends an exists message' do
        expect(api).to receive(:send_message).with(chat_id: message.chat.id, text: "Я уже наблюдаю за этим элементом.")
        described_class.call(bot: bot, message: message)
      end
    end

    context 'when there is an error creating the watch task' do
      before do
        allow(WatchTaskCreator).to receive(:call).with(url: 'http://example.com', selector: 'data-qa=title', chat_id: 1).and_return(Dry::Monads::Failure(:error))
      end

      it 'sends an error message' do
        expect(api).to receive(:send_message).with(chat_id: message.chat.id, text: "Не удалось установить наблюдение. Попробуйте позже.")
        described_class.call(bot: bot, message: message)
      end
    end
  end
end
