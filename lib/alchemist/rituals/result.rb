module Alchemist

  module Rituals

    class Result

      def initialize(&block)
        @block = block
      end

      def call(source)
        @block.call(source)
      end

    end

  end

end
