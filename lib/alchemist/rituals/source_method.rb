module Alchemist

  module Rituals

    class SourceMethod

      def initialize(method, &block)
        @method = method
        @block  = block
      end

      def call(source, result)
        result.instance_exec(source_value(source), &@block)
      end

      private

      def source_value(source)
        source.public_send(@method)
      rescue NoMethodError
        raise Errors::InvalidSourceMethod.new(@method)
      end

    end

  end

end
