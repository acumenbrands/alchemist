module Alchemist

  module Rituals

    class Transposition

      def initialize(&block)
        @block = block
      end

      def call(context)
        @context = context

        evaluate_block
        process_targets
      end

      private

      def evaluate_block
        merge comprehension
      end

      def comprehension
        Dsl::TransposeComprehension.new.tap do |comp|
          comp.instance_exec(&@block)
        end
      end

      def merge(comprehension)
        @source_methods = comprehension.source_methods
        @targets        = comprehension.targets
      end

      def source_proxy
        @source_proxy ||= @source_methods.each_with_object(OpenStruct.new) do |method_name, o|
          o.send("#{method_name}=", @context.source.public_send(method_name))
        end
      end

      def process_targets
        @targets.each do |target|
          target.call(target_context)
        end
      end

      def target_context
        @target_context ||= Context.new(source_proxy, @context.result)
      end

    end

  end

end
