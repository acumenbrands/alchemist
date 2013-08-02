require 'spec_helper'

describe Alchemist::Rituals::Transposition do

  let(:source_event) do
    OpenStruct.new(street: '101 Test Ln', state: 'AR', city: 'West Memphis')
  end

  let(:target_event) do
    OpenStruct.new(user_address: nil, shipping_address: nil)
  end

  let(:context) { Alchemist::Context.new(source_event, target_event) }

  let(:mutator_block) do
    Proc.new { "#{street}, #{city} #{state}" }
  end

  let(:transpose_block) do
    Proc.new do
      use :street, :state, :city

      target :user_address, :shipping_address do
        "#{street}, #{city} #{state}"
      end
    end
  end

  let(:expected_block_value) do
    source_event.instance_exec(&mutator_block)
  end

  describe '#call' do

    before do
      Alchemist::Rituals::Transposition.new(&transpose_block).call(context)
    end

    it 'sets user_address' do
      expect(target_event.user_address).to eq(expected_block_value)
    end

    it 'sets shipping_adddress' do
      expect(target_event.shipping_address).to eq(expected_block_value)
    end

  end

end
