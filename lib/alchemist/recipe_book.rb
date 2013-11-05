module Alchemist

  module RecipeBook
    extend self

    def write(source_type, result_type, trait=nil, &definition)
      Recipes[source_type][result_type][trait] = definition
    end

    def lookup(source_type, result_type, trait=nil)
      Reader.compile(
        base:    base_recipe(source_type, result_type),
        traited: traited_recipe(source_type, result_type, trait)
      )
    rescue ArgumentError
      raise_invalid(source_type, result_type, trait)
    end

    private

    def recipe_hash
      Hash.new { |recipes, source_type| recipes[source_type] = result_type_hash }
    end

    def result_type_hash
      Hash.new { |source_type, result_type| source_type[result_type] = {} }
    end

    def base_recipe(source_type, result_type)
      Recipes[source_type][result_type][nil]
    end

    def traited_recipe(source_type, result_type, trait)
      if trait && Recipes[source_type][result_type][trait].nil?
        raise_invalid(source_type, result_type, trait)
      end

      Recipes[source_type][result_type][trait]
    end

    def raise_invalid(source_type, result_type, trait)
      raise Errors::InvalidTransmutationMethod.new(source_type, result_type, trait)
    end

    Recipes = recipe_hash

  end

end
