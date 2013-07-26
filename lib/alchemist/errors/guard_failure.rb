module Alchemist

  module Errors

    class GuardFailure < TransmutationError

      def initialize(field)
        super "Guard operation for #{field} failed"
      end

    end

  end

end
