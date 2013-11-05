require 'spec_helper'

describe Alchemist::Dsl::RecipeComprehension do

  let(:comprehension) { Alchemist::Dsl::RecipeComprehension.new(&(Proc.new {})) }

  let(:result)       { double }
  let(:guard)        { double }
  let(:transfer)     { double }
  let(:aggregation)  { double }
  let(:distribution) { double }

  let(:source_field) { :source_field_name }
  let(:target_field) { :target_field_name }

  let(:dsl_block) { Proc.new {} }

  before do
    Alchemist::Rituals::Result.stub(:new)       { result }
    Alchemist::Rituals::Guard.stub(:new)        { guard }
    Alchemist::Rituals::Transfer.stub(:new)     { transfer }
    Alchemist::Rituals::Aggregation.stub(:new)  { aggregation }
    Alchemist::Rituals::Distribution.stub(:new) { distribution }
  end

  describe '#result' do

    before do
      comprehension.result(&dsl_block)
    end

    it 'creates a result ritual' do
      expect(Alchemist::Rituals::Result).to have_received(:new).with(&dsl_block)
    end

    it 'sets the result ritual' do
      expect(comprehension.result_ritual).to eq(result)
    end

  end

  describe '#guard' do

    before do
      comprehension.guard(source_field, &dsl_block)
    end

    it 'creates a guard object' do
      expect(Alchemist::Rituals::Guard).to have_received(:new).with(source_field, &dsl_block)
    end

    it 'adds the guard to the list' do
      expect(comprehension.guards[source_field]).to eq(guard)
    end

  end

  describe '#transfer' do

    let(:transfer_key) { [source_field, target_field] }

    before do
      comprehension.transfer(source_field, target_field, &dsl_block)
    end

    it 'creates a transfer object' do
      expect(Alchemist::Rituals::Transfer).to have_received(:new).with(
        source_field, target_field, &dsl_block
      )
    end

    it 'adds the transfer to the list' do
      expect(comprehension.transfers[transfer_key]).to eq(transfer)
    end

  end

  describe '#aggregate_onto' do

    before do
      comprehension.aggregate_onto(target_field, &dsl_block)
    end

    it 'creates a transfer object' do
      expect(Alchemist::Rituals::Aggregation).to have_received(:new).with(target_field, &dsl_block)
    end

    it 'adds the transfer to the list' do
      expect(comprehension.aggregations[target_field]).to eq(aggregation)
    end

  end

  describe '#distribute_from' do

    before do
      comprehension.distribute_from(source_field, &dsl_block)
    end

    it 'creates a transfer object' do
      expect(Alchemist::Rituals::Distribution).to have_received(:new).with(source_field, &dsl_block)
    end

    it 'adds the transfer to the list' do
      expect(comprehension.distributions[source_field]).to eq(distribution)
    end

  end

end
