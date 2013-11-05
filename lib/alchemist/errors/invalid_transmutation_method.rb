module Alchemist

  module Errors

    class InvalidTransmutationMethod < TransmutationError

      def initialize(source_type, target_type, trait)
        super "No transmutation method exists for: " +
          "from(#{source_type}), to(#{target_type}), trait(#{trait})"
      end

    end

  end

end
