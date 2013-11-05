require 'spec_helper'

describe Alchemist::Dsl::AggregationComprehension do

  let(:target_field) { :field_name }

  let(:comprehension) do
    Alchemist::Dsl::DistributionComprehension.new
  end

  describe '#target' do

    let(:process_block) do
      Proc.new { 'ZOGM' }
    end

    before do
      Alchemist::Target.stub(:new)
      comprehension.target target_field, &process_block
    end

    it 'creates a new Target with given method names and block' do
      expect(Alchemist::Target).to have_received(:new).with(target_field, &process_block)
    end

  end

end
