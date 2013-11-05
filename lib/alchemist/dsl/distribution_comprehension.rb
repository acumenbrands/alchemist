module Alchemist

  module Dsl

    class DistributionComprehension

      attr_reader :targets

      def initialize
        @targets = []
      end

      def target(target_field, &block)
        @targets << Target.new(target_field, &block)
      end

    end

  end

end
