module Alchemist

  class Recipe

    attr_reader :result_ritual, :guards, :transfers,
                :source_methods

    def self.read(&definition_block)
      Recipe.new.tap do |recipe|
        recipe.instance_exec(&definition_block)
      end
    end

    def initialize
      @guards              = []
      @transfers           = []
      @source_methods      = []
    end

    def get_result(source)
      @result_ritual.call(source)
    end

    def rituals
      guards + transfers + source_methods
    end

    def result(&block)
      @result_ritual = Rituals::Result.new(&block)
    end

    def guard(field_name, &block)
      @guards << Rituals::Guard.new(field_name, &block)
    end

    def transfer(source_field, target_field=nil, &block)
      @transfers << Rituals::Transfer.new(source_field, target_field, &block)
    end

    def source_method(method_name, &block)
      @source_methods << Rituals::SourceMethod.new(method_name, &block)
    end

  end

end
