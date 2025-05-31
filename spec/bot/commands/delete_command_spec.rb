require 'spec_helper'

RSpec.describe Bot::Commands::DeleteCommand do
  describe '.call' do
    let(:bot) { double('bot', api: double('api', send_message: nil)) }
    let(:message) { double('message', text: '/del 1', chat: double('chat', id: 123)) }

    context 'when snapshot exists' do
      let!(:snapshot) { Snapshot.create(chat_id: 123, id: 1) }

      it 'deletes the snapshot and sends a success message' do
        expect(bot.api).to receive(:send_message).with(chat_id: 123, text: 'Снимок с ID 1 удален.')
        described_class.call(bot: bot, message: message)
        expect(Snapshot[chat_id: 123, id: 1]).to be_nil
      end
    end

    context 'when snapshot does not exist' do
      it 'sends a message that snapshot is not found' do
        expect(bot.api).to receive(:send_message).with(chat_id: 123, text: 'Снимок с ID 1 не найден.')
        described_class.call(bot: bot, message: message)
      end
    end
  end
end
