module Alchemist

  module Rituals

    class Transfer

      # - Block and target field should be optional
      # - Assign return value of the block to the target field
      # - Target field is source_field if result_field is not given
      def initialize(source_field, result_field=nil, &block)
        @source_field = source_field
        @result_field = result_field
        @block        = block
      end

      def call(source, result)
        @source = source
        result.public_send(mutator, value)
      rescue NoMethodError
        raise Errors::NoResultFieldForTransfer.new(mutator)
      end

      private

      def value
        block_value || source_value
      end

      def block_value
        @block.call(source_value) if @block
      end

      def source_value
        @source.public_send(@source_field)
      end

      def mutator
        # @target_field can be nil in the event that the field names
        # are the same between objects
        "#{@result_field || @source_field}="
      end

    end

  end

end
