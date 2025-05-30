require 'spec_helper'
require 'bot/commands/unknown_command'

RSpec.describe Bot::Commands::UnknownCommand do
  let(:bot) { double('bot', api: api) }
  let(:api) { double('api') }
  let(:message) { double('message', text: '/unknown', chat: double('chat', id: 1)) }

  describe '.call' do
    it 'sends an unknown command message' do
      expect(api).to receive(:send_message).with(chat_id: message.chat.id, text: "Неверный формат. Используйте /watch <url> <css_selector>")
      described_class.call(bot: bot, message: message)
    end
  end
end
