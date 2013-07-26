require 'spec_helper'

describe Alchemist::Recipe do

  let(:recipe) { Alchemist::Recipe.new }

  describe '#result' do

    let(:result_block) { Proc.new { |source| Class.new } }

    before do
      recipe.result(&result_block)
    end

    it 'initializes a new instance of Alchemist::Rituals::Result' do
      expect(recipe.result).to be_kind_of(Alchemist::Rituals::Result)
    end

  end

  describe '#guard' do

    let(:field_name)  { :arbitrary_field }
    let(:guard_block) { Proc.new { |source_field| !source_field.nil? } }

    before do
      recipe.guard(field_name, &guard_block)
    end

    it 'initializes a new instance of Alchemist::Rituals::Guard' do
      expect(recipe.guards.first).to be_kind_of(Alchemist::Rituals::Guard)
    end

  end

  describe '#transfer' do

    let(:source_field) { :the_field }
    let(:target_field) { :target_field }
    let(:block)        { Proc.new { |target_field| !target_field.nil? } }

    before do
      recipe.transfer(source_field, target_field, &block)
    end
    
    it 'adds an instance of Alchemist::Rituals::Transfer to an array' do
      expect(recipe.transfers.first).to be_kind_of(Alchemist::Rituals::Transfer)
    end

  end

  describe '#source_methods' do

    let(:source_method) { :albatross }
    let(:block) { Proc.new { |value| value.to_s } }

    before do
      recipe.source_method(source_method, &block)
    end

    it 'adds an instance of Alchemist::Rituals::SourceMethod to an array' do
      expect(recipe.source_methods.first).to be_kind_of(Alchemist::Rituals::SourceMethod)
    end

  end

end
