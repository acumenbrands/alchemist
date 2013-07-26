module Alchemist

  module Rituals

    class AlterResult

      def initialize(field, &block)
        @field = field
        @block = &block
      end

      def call(source, result)
        result.instance_exec(field_value(result), &@block)
      end

      private

      def field_value(result)
        result.public_send(@field)
      end

    end

  end

end
