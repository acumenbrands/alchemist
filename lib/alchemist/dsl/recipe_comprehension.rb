module Alchemist

  module Dsl

    class RecipeComprehension

      attr_accessor :result_ritual, :guards, :transfers,
                    :aggregations, :distributions

      def initialize(&definition_block)
        @guards         = {}
        @transfers      = {}
        @aggregations   = {}
        @distributions  = {}

        instance_exec(&definition_block)
      end

      def result(&block)
        @result_ritual = Rituals::Result.new(&block)
      end

      def guard(field_name, &block)
        @guards[field_name] = Rituals::Guard.new(field_name, &block)
      end

      def transfer(source_field, target_field=nil, &block)
        transfer_key = [source_field, target_field]
        @transfers[transfer_key] = Rituals::Transfer.new(source_field, target_field, &block)
      end

      def aggregate_onto(target_field, &block)
        @aggregations[target_field] = Rituals::Aggregation.new(target_field, &block)
      end

      def distribute_from(source_field, &block)
        @distributions[source_field] = Rituals::Distribution.new(source_field, &block)
      end

    end

  end

end
