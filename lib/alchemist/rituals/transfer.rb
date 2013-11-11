module Alchemist

  module Rituals

    class Transfer

      def initialize(source_field, result_field=nil, &block)
        @source_field = source_field
        @result_field = result_field
        @block        = block
      end

      def call(context)
        @context = context
        @context.result.public_send(target_method, argument)
      rescue NoMethodError, ArgumentError
        raise Errors::InvalidResultMethodForTransfer.new(target_method)
      end

      private

      def argument
        block_value || source_value
      end

      def block_value
        @block.call(source_value) if @block
      end

      def source_value
        @context.source.public_send(@source_field)
      end

      def target_method
        if @context.result.respond_to?(result_mutator)
          result_mutator
        else
          result_method
        end
      end

      def result_method
        @result_field || @source_field
      end

      def result_mutator
        "#{result_method}="
      end

    end

  end

end
