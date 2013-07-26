module Alchemist

  module Errors

    class InvalidTransmutationMethod < StandardError

      def initialize(from_type, to_type, traits)
        super "No transmutation method exists for: from(#{attempted_method}), " +
          "to(#{to_type}), traits(#{traits})"
      end

    end

  end

end
