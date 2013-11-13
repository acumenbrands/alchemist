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

        @context.result.public_send(target_method, *arguments)
      rescue NoMethodError => e
        case e.name
        when target_method then raise Errors::InvalidResultMethodForTransfer.new(target_method)
        when source_method then raise Errors::InvalidSourceMethodForTransfer.new(source_Method)
        else raise e
        end
      rescue ArgumentError => e
        raise Errors::InvalidResultMethodForTransfer.new(target_method)
      end

      private

      def hash_like_result?
        @context.result.respond_to?(:[]=)
      end

      def hash_like_source?
        @context.source.respond_to?(:[])
      end

      def arguments
        [].tap do |args|
          args << result_method if hash_like_result?
          args << (block_value || source_value)
        end
      end

      def block_value
        @block.call(source_value) if @block
      end

      def source_value
        @context.source.public_send(*source_method)
      end

      def source_method
        [].tap do |args|
          args << :[] if hash_like_source?
          args << @source_field
        end
      end

      def target_method
        if hash_like_result?
          :[]=
        elsif @context.result.respond_to?(result_mutator)
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
