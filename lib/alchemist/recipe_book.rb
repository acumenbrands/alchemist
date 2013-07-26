module Alchemist

  module RecipeBook
    extend self

    # Default dispatcher is a lambda that returns no traits ([]). This
    # enables source entities to have a default case of no traits, and also
    # enables us to have multiple traits on a record type.
    @trait_dispatchers = Hash.new { lambda { |_| nil } }

    @types = {}

    def trait_dispatch(ns_type, &block)
      @trait_dispatchers[source_object, to_type] = block
    end

    def trip(source_object, to_type, trait=nil, &definition_block)
      @types[[source_object, to_type, trait]] = RecordTranslator.build(&definition_block)
    end

    def lookup(source_object, to_type)
      trait = @trait_dispatchers[[source_object, to_type]].call(source_object)
      @types[[source_object, to_type, trait]] ||
        raise(::Alchemist::Errors::InvalidTransmutationMethod.new(source_object, target, trait))
    end

  end

end
