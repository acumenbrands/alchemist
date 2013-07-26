require 'spec_helper'

describe Alchemist::RecipeBook do

  let(:recipes)     { Alchemist::RecipeBook::Recipes }
  let(:recipe_proc) { Proc.new { "Try not to burn anything expensive" } }

  before do
    stub_const("SourceClass", Class.new)
    stub_const("ResultClass", Class.new)
  end

  describe '#write' do

    let(:write_recipe) {
      Alchemist::RecipeBook::write(SourceClass, ResultClass, &recipe_proc)
    }


    it 'stores the given proc in a nested hash under the source and result constants' do
      expect { write_recipe }.to change { recipes[SourceClass][ResultClass] }
        .from(nil).to(recipe_proc)
    end

  end

  describe '#lookup' do

    let(:lookup) { Alchemist::RecipeBook.lookup(SourceClass, ResultClass) }

    context 'a source and result constant pair that match a recipe proc are given' do

      before do
        recipes[SourceClass][ResultClass] = recipe_proc
      end

      it 'returns a new instance of Recipe built with the proc' do
        expect(lookup).to be_kind_of(Alchemist::Recipe)
      end

    end

    context 'a source and result constant pair that does not match a recipe proc is given' do

      let(:expected_error) { Alchemist::Errors::InvalidTransmutationMethod }

      it 'raises an InvalidTransmutationMethod exception' do
        expect { lookup }.to raise_error(expected_error)
      end

    end

  end

end
