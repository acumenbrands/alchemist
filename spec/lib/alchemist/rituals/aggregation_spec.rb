require 'spec_helper'

describe Alchemist::Rituals::Aggregation do

  let(:source_event) do
    OpenStruct.new(street: '101 Test Ln', state: 'AR', city: 'West Memphis')
  end

  let(:target_event) do
    OpenStruct.new(address: nil)
  end

  let(:target_field) { :address }

  let(:context) { Alchemist::Context.new(source_event, target_event) }

  let(:mutator_block) do
    Proc.new { "#{street}, #{city} #{state}" }
  end

  let(:aggregate_block) do
    Proc.new do
      from :street, :state, :city

      with do
        "#{street}, #{city} #{state}"
      end
    end
  end

  let(:expected_block_value) do
    source_event.instance_exec(&mutator_block)
  end

  describe '#call' do

    before do
      Alchemist::Rituals::Aggregation.new(target_field, &aggregate_block).call(context)
    end

    it 'sets the address' do
      expect(target_event.address).to eq(expected_block_value)
    end

  end

end
