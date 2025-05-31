require_relative '../../spec_helper'
require 'bot/commands/watch_command'

RSpec.describe Bot::Commands::WatchCommand do
  let(:bot) { double('bot', api: api) }
  let(:api) { double('api') }
  let(:message) { double('message', text: '/watch http://example.com data-qa=title', chat: double('chat', id: 1)) }

  describe '.call' do
    context 'when watch task is created' do
      it 'sends a success message' do
        expect(api).to receive(:send_message).with(chat_id: message.chat.id, text: "Теперь слежу за http://example.com с атрибутом data-qa=title.")
        described_class.call(bot: bot, message: message)
      end
    end

    context 'when watch task already exists' do
      let!(:snapshot) { create(:snapshot, chat_id: 1, url: 'http://example.com', attribute_query: 'data-qa=title') }

      it 'sends an exists message' do
        expect(api).to receive(:send_message).with(chat_id: message.chat.id, text: "Я уже наблюдаю за этим элементом.")
        described_class.call(bot: bot, message: message)
      end
    end

    context 'when there is an error creating the watch task' do

      it 'sends an error message' do
        expect(api).to receive(:send_message).with(chat_id: message.chat.id, text: "Не удалось установить наблюдение. Попробуйте позже.")
        described_class.call(bot: bot, message: message)
      end
    end
    context 'when watch task limit is exceeded' do
      before do
        stub_const('MAX_SNAPSHOTS_PER_CHAT', 2)
        create_list(:snapshot, 2, chat_id: 1)
      end

      it 'sends a limit exceeded message' do
        expect(api).to receive(:send_message).with(chat_id: message.chat.id, text: "Вы добавили слишком много отслеживаемых элементов. Доступно не более 2.")
        described_class.call(bot: bot, message: message)
      end
    end
  end
end
