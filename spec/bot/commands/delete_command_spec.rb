require 'spec_helper'

RSpec.describe Bot::Commands::DeleteCommand do
  describe '.call' do
    let(:bot) { double('bot', api: double('api', send_message: nil)) }
    let(:chat_id) { 123 }
    let!(:snapshot) { Snapshot.create(chat_id: chat_id) }
    let(:message) { double('message', text: "/del #{snapshot.id}", chat: double('chat', id: chat_id)) }

    context 'when snapshot exists' do
      let!(:snapshot2) { Snapshot.create(chat_id: chat_id) }

      it 'deletes the snapshot and sends a success message' do
        expect(bot.api).to receive(:send_message).with(chat_id: 123, text: "Снимок с ID #{snapshot.id} удален.")
        described_class.call(bot: bot, message: message)
        expect(Snapshot[snapshot2.id]).to be
        expect(Snapshot[snapshot.id]).to be_nil
      end
    end

    context 'when snapshot does not exist' do
      before { snapshot.destroy }
      it 'sends a message that snapshot is not found' do
        expect(bot.api).to receive(:send_message).with(chat_id: 123, text: "Снимок с ID #{snapshot.id} не найден.")
        described_class.call(bot: bot, message: message)
      end
    end

    context 'when snapshot id does not match chat_id' do
      let(:message) { double('message', text: "/del #{snapshot.id}", chat: double('chat', id: 456)) }

      it 'sends a message that snapshot is not found' do
        expect(bot.api).to receive(:send_message).with(chat_id: 123, text: "Снимок с ID #{snapshot.id} не найден.")
        described_class.call(bot: bot, message: message)
      end
    end
  end
end
