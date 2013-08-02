module Alchemist

  module Dsl

    class RecipeComprehension

      attr_reader :result_ritual, :guards, :transfers, :transpositions

      def initialize
        @guards         = []
        @transfers      = []
        @transpositions = []
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

      def transpose(&block)
        @transpositions << Rituals::Transposition.new(&block)
      end

    end

  end

end
