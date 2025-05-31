require 'spec_helper'

RSpec.describe CheckTaskWorker do
  describe '#perform' do
    let(:worker) { described_class.new }

    it 'performs the task successfully' do
      chat_id = 123
      message = 'Test message'
      allow_any_instance_of(Bot::Client).to receive(:send_message).with(chat_id: chat_id, text: message)
      
      # Add your test logic here
    end
  end
end
