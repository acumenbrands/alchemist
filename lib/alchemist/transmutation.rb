module Alchemist

  class Transmutation

    attr_reader :source, :result_type, :recipe, :result

    def initialize(source, result_type)
      @source      = source
      @result_type = result_type
      @result      = recipe.get_result(source)
    end

    def process
      recipe.rituals.each { |ritual| ritual.call(context) }
    end

    private

    def source_type
      @source.class
    end

    def recipe
      @recipe ||= RecipeBook.lookup(source_type, result_type)
    end

    def context
      @context ||= Context.new(source, result)
    end

  end

end

