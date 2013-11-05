require 'spec_helper'

describe Alchemist::Recipe do

  let(:recipe) { Alchemist::Recipe.read(&ritual_block) }

  describe 'result rituals' do

    let(:ritual_block) do
      Proc.new { result { Class.new } }
    end

    it 'initializes a new instance of Alchemist::Rituals::Result' do
      expect(recipe.result_ritual).to be_kind_of(Alchemist::Rituals::Result)
    end

  end

  describe 'guard rituals' do

    let(:ritual_block) do
      Proc.new do
        guard :source_field do |field_value|
          "#{field_value}"
        end
      end
    end

    it 'initializes a new instance of Alchemist::Rituals::Guard' do
      expect(recipe.guard_for(:source_field)).to be_kind_of(Alchemist::Rituals::Guard)
    end

  end

  describe 'transfer_rituals' do

    let(:ritual_block) do
      Proc.new do
        transfer :source_field
      end
    end

    it 'initializes a new instance of Alchemist::Rituals::Transfer' do
      expect(recipe.transfer_for(:source_field)).to be_kind_of(Alchemist::Rituals::Transfer)
    end

  end

  describe 'aggregation rituals' do

    let(:ritual_block) do
      Proc.new do
        aggregate_onto :target_field do
          from :source_field, :other_source_field

          with do
            source_field + other_source_field
          end
        end
      end
    end

    it 'initializes a new instance of Alchemist::Rituals::Aggregation' do
      expect(recipe.aggregation_for(:target_field)).to be_kind_of(Alchemist::Rituals::Aggregation)
    end

  end

  describe 'distribution rituals' do

    let(:ritual_block) do
      Proc.new do
        distribute_from :source_field do
          target :target_field, :other_target_field do
            source_field + 7
          end
        end
      end
    end

    it 'initializes a new instance of Alchemist::Rituals::Distribution' do
      expect(recipe.distribution_for(:source_field)).to be_kind_of(Alchemist::Rituals::Distribution)
    end

  end

  describe '#merge!' do

    let(:ritual_block) { Proc.new {} }

    let(:result_ritual) { double }
    let(:guard)         { double }
    let(:transfer)      { double }
    let(:aggregation)   { double }
    let(:distribution)  { double }

    let(:comprehension) do
      OpenStruct.new(
        result_ritual: result_ritual,
        guards:        { source_field:           guard },
        transfers:     { [:source_field, nil] => transfer },
        aggregations:  { target_field:           aggregation },
        distributions: { source_field:           distribution }
      )
    end

    let(:merge) { recipe.merge!(comprehension) }

    it 'updates the result ritual' do
      expect { merge }.to change { recipe.result_ritual }.to(result_ritual)
    end

    it 'updates the guards' do
      expect { merge }.to change { recipe.guards }.to(comprehension.guards)
    end

    it 'updates the transfers' do
      expect { merge }.to change { recipe.transfers }.to(comprehension.transfers)
    end

    it 'updates the aggregations' do
      expect { merge }.to change { recipe.aggregations }.to(comprehension.aggregations)
    end

    it 'updates the distributions' do
      expect { merge }.to change { recipe.distributions }.to(comprehension.distributions)
    end

  end

end
