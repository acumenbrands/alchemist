module Alchemist

  module Errors

    class NoTargetReceived < TransmutationError

      def initialize(source_object)
        super "No target object was found for #{source_object.inspect}"
      end

    end

  end

end
