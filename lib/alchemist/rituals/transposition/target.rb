module Alchemist

  module Rituals

    class Transposition

      class Target

        def initialize(*method_names, &block)
          @method_names  = method_names
          @block         = block
        end

        def call(context)
          @context = context

          perform_transfers
        end

        private

        def perform_transfers
          @method_names.each do |method_name|
            Transfer.new(method_name).call(transfer_context)
          end
        end

        def value_struct
          @value_struct ||= @method_names.each_with_object(OpenStruct.new) do |method_name, o|
            o.send("#{method_name}=", block_value)
          end
        end

        def transfer_context
          @transfer_context ||= Context.new(value_struct, @context.result)
        end

        def block_value
          @block_value ||= @context.source.instance_exec(&@block)
        end

      end

    end

  end

end
