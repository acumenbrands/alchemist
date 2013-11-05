require 'spec_helper'

describe Alchemist::Reader do

  let(:base_block)    { Proc.new {} }
  let(:traited_block) { Proc.new {} }

  let(:base)    { double }
  let(:traited) { double }

  describe '#build' do

    let(:recipes) do
      {
        base:    base_block,
        traited: traited_block
      }
    end

    let(:build) { Alchemist::Reader.build(recipes) }

    before do
      Alchemist::Reader.stub(:comprehend).with(base_block)    { base }
      Alchemist::Reader.stub(:comprehend).with(traited_block) { traited }
    end

    context 'both a base and traited recipe are given' do

      before { build }

      it 'calls comprehend with base' do
        expect(Alchemist::Reader).to have_received(:comprehend).with(base_block)
      end

      it 'calls comprehend with traited' do
        expect(Alchemist::Reader).to have_received(:comprehend).with(traited_block)
      end

      it 'populates the base recipe instance' do
        expect(build[:base]).to eq(base)
      end

      it 'populates the traited recipe instance' do
        expect(build[:traited]).to eq(traited)
      end

    end

    context 'neither a base nor a traited recipe are given' do

      let(:recipes) do
        {
          base:    nil,
          traited: nil
        }
      end

      it 'raises an ArgumentError' do
        expect { build }.to raise_error(ArgumentError)
      end

    end

  end

end
