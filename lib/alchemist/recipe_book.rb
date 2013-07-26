module Alchemist

  module RecipeBook
    extend self

    Recipes = Hash.new { |hash, key| hash[key] = {} }

    def write(source_type, result_type, &definition)
      Recipes[source_type][result_type] = definition
    end

    def lookup(source_type, target_type)
      directions = Recipes[source_type][target_type]

      if directions
        Recipe.read(&directions)
      else
        raise Errors::InvalidTransmutationMethod.new(source_type, target_type)
      end
    end

  end

end
