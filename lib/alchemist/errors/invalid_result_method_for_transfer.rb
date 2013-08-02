module Alchemist

  module Errors

    class InvalidResultMethodForTransfer < TransmutationError

      def initialize(method)
        super("Result object does not have a #{method} method defined")
      end

    end

  end

end
