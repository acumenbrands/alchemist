module Alchemist

  module Rituals

    class Distribution

      def initialize(source_field, &block)
        @source_field = source_field
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
        Dsl::DistributionComprehension.new.tap do |comp|
          comp.instance_exec(&@block)
        end
      end

      def merge(comprehension)
        @targets = comprehension.targets
      end

      def source_proxy
        OpenStruct.new.tap do |struct|
          struct.send("#{@source_field}=", @context.source.public_send(@source_field))
        end
      end

      def process_target
        @targets.each { |target| target.call(target_context) }
      end

      def target_context
        @target_context ||= Context.new(source_proxy, @context.result)
      end

    end

  end

end
