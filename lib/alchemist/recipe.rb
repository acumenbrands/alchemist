module Alchemist

  class Recipe

    attr_reader :guards, :transfers, :transpositions, :result_ritual

    def self.read(&definition_block)
      comprehension = Dsl::RecipeComprehension.new.tap do |dsl|
        dsl.instance_exec(&definition_block)
      end

      Recipe.new(comprehension)
    end

    def initialize(comprehension)
      @result_ritual  = comprehension.result_ritual
      @guards         = comprehension.guards
      @transfers      = comprehension.transfers
      @transpositions = comprehension.transpositions
    end

    def get_result(source)
      @result_ritual.call(source)
    end

    def rituals
      guards + transfers + transpositions
    end

  end

end
