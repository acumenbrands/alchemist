module Alchemist

  class Recipe

    attr_reader :finder_block, :guards, :translators, :target_translators

    def initialize
      @guards              = {}
      @translators         = {}
      @target_translators  = {}
    end

    def finder(&block)
      @finder_block = block
    end

    def guard(field_name, &block)
      @guards[field_name] = block
    end

    def field(name, &block)
      @translators[name] = block
    end

    # Like field, but translates records within the target rather than from
    # source to target.
    #
    def target_field(field_name, &block)
      @target_translators[field_name] = block
    end

  end

end
