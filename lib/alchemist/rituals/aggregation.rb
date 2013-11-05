module Alchemist

  module Rituals

    class Aggregation

      def initialize(target_field, &block)
        @target_field = target_field
        @block        = block
      end

      def call(context)
        @context = context

        evaluate_block
        process_target
      end

      private

      def evaluate_block
        merge comprehension
      end

      def comprehension
        Dsl::AggregationComprehension.new(@target_field).tap do |comp|
          comp.instance_exec(&@block)
        end
      end

      def merge(comprehension)
        @source_methods = comprehension.source_methods
        @target         = comprehension.target
      end

      def source_proxy
        @source_proxy ||= @source_methods.each_with_object(OpenStruct.new) do |method_name, o|
          o.send("#{method_name}=", @context.source.public_send(method_name))
        end
      end

      def process_target
        @target.call(target_context)
      end

      def target_context
        @target_context ||= Context.new(source_proxy, @context.result)
      end

    end

  end

end
