module Alchemist

  class Context

    attr_reader :source, :result

    def initialize(source, result)
      @source = source
      @result = result
    end

  end

end
