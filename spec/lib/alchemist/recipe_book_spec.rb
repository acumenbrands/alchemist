require 'spec_helper'

describe Alchemist::RecipeBook do

  let(:recipes)     { Alchemist::RecipeBook::Recipes }
  let(:recipe_proc) { Proc.new { "Try not to burn anything expensive" } }

  before do
    stub_const("SourceClass", Class.new)
    stub_const("ResultClass", Class.new)
  end

  describe '#write' do

    context 'no trait is given' do

      let(:write_recipe) {
        Alchemist::RecipeBook::write(SourceClass, ResultClass, &recipe_proc)
      }

      it 'stores the given proc in a nested hash under the source and result constants' do
        expect { write_recipe }.to change { recipes[SourceClass][ResultClass][nil] }
          .from(nil).to(recipe_proc)
      end

    end

    context 'a trait is defined' do

      let(:write_recipe) {
        Alchemist::RecipeBook::write(SourceClass, ResultClass, :trait, &recipe_proc)
      }

      it 'stores the given proc in a nested hash under the source and result constants' do
        expect { write_recipe }.to change { recipes[SourceClass][ResultClass][:trait] }
          .from(nil).to(recipe_proc)
      end

    end

  end

  describe '#lookup' do

    let(:base)    { double }
    let(:traited) { double }

    let(:recipe_hash) do
      {
        base:    base,
        traited: traited
      }
    end

    let(:lookup) { Alchemist::RecipeBook.lookup(Class, Object, :trait) }

    context ' no ArgumentError is raised' do

      before do
        Alchemist::Reader.stub(:compile)
        Alchemist::RecipeBook.stub(:base_recipe)    { base }
        Alchemist::RecipeBook.stub(:traited_recipe) { traited }

        lookup
      end

      it 'calls Reader.compile with results of the recipe lookups' do
        expect(Alchemist::Reader).to have_received(:compile).with(recipe_hash)
      end

    end

    context 'an invalid trait is given' do

      it 'raises an InvalidTransmutationMethod exception' do
        expect { lookup }.to raise_error(Alchemist::Errors::InvalidTransmutationMethod)
      end

    end

    context 'an ArgumentError is raised' do

      before do
        Alchemist::Reader.stub(:compile) { raise ArgumentError.new }
      end

      it 'raises an InvalidTransmutationMethod exception' do
        expect { lookup }.to raise_error(Alchemist::Errors::InvalidTransmutationMethod)
      end

    end

  end

end
