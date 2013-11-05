require 'spec_helper'

describe Alchemist::Rituals::Distribution do

  let(:source_field) { :address }

  let(:source_object) do
    OpenStruct.new(address: 'BobJones\n64 Shady Ln\nTownsville XX 12345')
  end

  let(:target_object) do
    OpenStruct.new(address: nil, shipping_address: nil)
  end

  let(:context) { Alchemist::Context.new(source_object, target_object) }

  let(:distribution_block) do
    Proc.new do
      target :address do
        address.split('\n')[1..2].join('\n')
      end

      target :shipping_address do
        address
      end
    end
  end

  let(:address_block) do
    Proc.new { address.split('\n')[1..2].join('\n') }
  end

  let(:shipping_address_block) do
    Proc.new { address }
  end

  let(:expected_address)          { source_object.instance_exec(&address_block) }
  let(:expected_shipping_address) { source_object.instance_exec(&shipping_address_block) }

  describe '#call' do

    before do
      Alchemist::Rituals:: Distribution.new(source_field, &distribution_block).call(context)
    end

    it 'sets the address' do
      expect(target_object.address).to eq(expected_address)
    end

    it 'sets the shipping address' do
      expect(target_object.shipping_address).to eq(expected_shipping_address)
    end

  end

end
