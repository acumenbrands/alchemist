module Alchemist

  class Reactor < Struct.new(:finder, :guards, :translators,
                                :target_translators)

    def self.build(&block)
      recipe = ::Alchemist::Recipe.new
      recipe.instance_eval(&block)
      new(recipe.finder_block,
          recipe.guards,
          recipe.translators,
          recipe.target_translators)
    end

    # Empty record types define cases that are ignored without translation.
    #
    # Example:
    #
    #     record_type SourceObject, TargetObject, :discount do
    #       # this will throw away these records without translating them
    #     end
    #
    def empty?
      finder.nil?
    end

    def find(netsuite_record)
      finder.call(netsuite_record)
    end

    def transmute(source_object, target)
      # Run all the guard blocks, any of which might raise.
      guards.each do |field_name, guard|
        target.instance_exec(source_object.send(field_name), &guard)
      end

      # Run all source-field-specific translators
      translators.each do |field_name, translator|
        target.instance_exec(source_object.send(field_name), &translator)
      end

      # Finally, run all target-to-target field mappings.
      target_translators.each do |field_name, translator|
        target.instance_exec(target[field_name], &translator)
      end
    end

  end

end
