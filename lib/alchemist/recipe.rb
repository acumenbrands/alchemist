module Alchemist

  class Recipe

    attr_reader :guards, :transfers, :aggregations,
                :result_ritual, :distributions

    def self.read(&definition_block)
      new(Dsl::RecipeComprehension.new(&definition_block))
    end

    def initialize(comprehension)
      @result_ritual  = comprehension.result_ritual
      @guards         = comprehension.guards
      @transfers      = comprehension.transfers
      @aggregations   = comprehension.aggregations
      @distributions  = comprehension.distributions
    end

    def get_result(source)
      @result_ritual.call(source)
    end

    def rituals
      [guards, transfers, aggregations, distributions].map(&:values).flatten
    end

    def guard_for(field_name)
      guards[field_name]
    end

    def transfer_for(source_field, target_field=nil)
      transfers[[source_field, target_field]]
    end

    def aggregation_for(field_name)
      aggregations[field_name]
    end

    def distribution_for(field_name)
      distributions[field_name]
    end

    # NOTE (JamesChristie): This accepts either a Recipe or RecipeComprehension
    def merge!(comprehension)
      @result_ritual = comprehension.result_ritual || result_ritual
      @guards        = guards.merge(comprehension.guards)
      @transfers     = transfers.merge(comprehension.transfers)
      @aggregations  = aggregations.merge(comprehension.aggregations)
      @distributions = distributions.merge(comprehension.distributions)
    end

  end

end
