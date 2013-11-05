module Alchemist

  module Reader
    extend self

    def compile(recipes)
      merge(build(recipes))
    end

    def merge(recipes)
      recipes[:base].tap do |base|
        base.merge!(recipes[:traited]) if both_present?(recipes)
      end
    end

    def build(recipes)
      raise_invalid unless one_present?(recipes)

      Hash.new.tap do |recipe_hash|
        recipe_hash[:base]    = comprehend(recipes[:base])    if recipes[:base]
        recipe_hash[:traited] = comprehend(recipes[:traited]) if recipes[:traited]
      end
    end

    def comprehend(instructions)
      Recipe.read(&instructions)
    end

    def raise_invalid
      raise ArgumentError.new("No recipes were found")
    end

    def one_present?(recipes)
      recipes[:base] || recipes[:traited]
    end

    def both_present?(recipes)
      recipes[:base] && recipes[:traited]
    end

  end

end
