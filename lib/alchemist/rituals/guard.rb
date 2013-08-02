module Alchemist

  module Rituals

    class Guard

      def initialize(field, &block)
        @field = field
        @block = block
      end

      def call(context)
        @context = context

        unless @context.result.instance_exec(field_value, &@block)
          raise Errors::GuardFailure.new(@field)
        end
      end

      private

      def field_value
        @context.source.public_send(@field)
      end

    end

  end

end
