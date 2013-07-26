module Alchemist

  module Errors

    class TransmutationError < StandardError

      def initialize(message)
        super(message)
      end

    end

  end

end
