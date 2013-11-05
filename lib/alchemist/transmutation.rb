module Alchemist

  class Transmutation

    attr_reader :source, :result_type, :trait, :recipe, :result

    def initialize(source, result_type, trait=nil)
      @source      = source
      @result_type = result_type
      @trait       = trait
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
      @recipe ||= RecipeBook.lookup(source_type, result_type, trait)
    end

    def context
      @context ||= Context.new(source, result)
    end

  end

end
