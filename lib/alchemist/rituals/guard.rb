module Alchemist

  module Rituals

    class Guard

      def initialize(field, &block)
        @field = field
        @block = block
      end

      def call(source, result)
        unless result.instance_exec(field_value(source), &@block)
          raise Errors::GuardFailure.new(@field)
        end
      end

      private

      def field_value(source)
        source.public_send(@field)
      end

    end

  end

end
