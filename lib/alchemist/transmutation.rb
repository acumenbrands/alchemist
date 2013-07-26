module Alchemist

  # Represents a translation from a given NetSuite record into Honest Engine
  # objects.
  #
  class Transmutation

    def initialize(source_object, result_type)
      @source_object = source_object
      @result_type   = result_type
      @recipe        = ::Alchemist::RecipeBook.lookup(@source_object, @result_type)
    end

    # Find or create the target of the translation.
    #
    def target
      @target ||= @recipe.find(@source_object) ||
        raise("The finder returned no results for #{@source_object.inspect}")
    end

    # Run the translation into +target+, but do not save the record.
    #
    def perform
      return if @recipe.empty?

      @recipe.transmute(@source_object, target)
    end

  end

end

