require 'spec_helper'

describe Alchemist do

  describe '.transmute' do
    
    context "happy path" do

      let(:type)   { Array }
      let(:source) { Hash.new }
      let(:result) { Hash.new }

      let(:transmute) { Alchemist.transmute(source, type) }

      it "returns an instance of a transmuted record" do
        expect(transmute).to eq(result)
      end
    end

  end
end
