require 'spec_helper'

describe Alchemist::Dsl::AggregationComprehension do

  let(:target_field) { :field_name }

  let(:comprehension) do
    Alchemist::Dsl::AggregationComprehension.new(target_field)
  end

  describe '#from' do

    let(:used_method) { :method_name }

    before do
      comprehension.from used_method
    end

    it 'adds the specified method to the list of source methods' do
      expect(comprehension.source_methods).to include(used_method)
    end

  end

  describe '#with' do

    let(:process_block) do
      Proc.new { 'ZOGM' }
    end

    before do
      Alchemist::Target.stub(:new)
      comprehension.with &process_block
    end

    it 'creates a new Target with given method names and block' do
      expect(Alchemist::Target).to have_received(:new).with(target_field, &process_block)
    end

  end

end
