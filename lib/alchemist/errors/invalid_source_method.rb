module Alchemist

  module Errors

    class InvalidSourceMethod < TransmutationError
      
      def initialize(method)
        super("#{method} is not a method specified on the source object")
      end

    end

  end

end
