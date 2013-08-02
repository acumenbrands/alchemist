require 'spec_helper'

describe Alchemist::Recipe do

  describe 'result rituals' do

    it 'initializes a new instance of Alchemist::Rituals::Result' do
      result_block = Proc.new do
        result { Class.new }
      end

      recipe = Alchemist::Recipe.read(&result_block) 

      expect(recipe.result_ritual).to be_kind_of(Alchemist::Rituals::Result)
    end

  end

  describe 'guard rituals' do

    it 'initializes a new instance of Alchemist::Rituals::Guard' do
      guard_block = Proc.new do
        guard :source_field do |source_field| 
          !source_field.nil
        end
      end

      recipe = Alchemist::Recipe.read(&guard_block)
      expect(recipe.guards.first).to be_kind_of(Alchemist::Rituals::Guard)
    end

  end

  describe 'transfer rituals' do

    it 'adds an instance of Alchemist::Rituals::Transfer to an array' do
      block = Proc.new do
        transfer :source_field, :target_field do |source_value|
          source_value * 2
        end
      end

      recipe = Alchemist::Recipe.read(&block)
      expect(recipe.transfers.first).to be_kind_of(Alchemist::Rituals::Transfer)
    end

  end

end
