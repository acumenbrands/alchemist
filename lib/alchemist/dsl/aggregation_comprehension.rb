module Alchemist

  module Dsl

    class AggregationComprehension

      attr_reader :source_methods, :target

      def initialize(target_field)
        @source_methods = []
        @target_field   = target_field
      end

      def from(*method_names)
        @source_methods.concat(method_names)
      end

      def with(&block)
        @target = Target.new(@target_field, &block)
      end

    end

  end

end
