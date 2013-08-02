module Alchemist

  module Dsl

    class TransposeComprehension

      attr_reader :source_methods, :targets

      def initialize
        @source_methods = []
        @targets        = []
      end

      def use(*method_names)
        @source_methods.concat(method_names)
      end

      def target(*method_names, &block)
        targets << Rituals::Transposition::Target.new(*method_names, &block)
      end

    end

  end

end
