require 'ostruct'

require_relative 'alchemist/recipe_book'
require_relative 'alchemist/recipe'
require_relative 'alchemist/reader'
require_relative 'alchemist/transmutation'
require_relative 'alchemist/context'
require_relative 'alchemist/target'

require_relative 'alchemist/dsl/recipe_comprehension'
require_relative 'alchemist/dsl/aggregation_comprehension'
require_relative 'alchemist/dsl/distribution_comprehension'

require_relative 'alchemist/rituals/result'
require_relative 'alchemist/rituals/guard'
require_relative 'alchemist/rituals/transfer'
require_relative 'alchemist/rituals/aggregation'
require_relative 'alchemist/rituals/distribution'

require_relative 'alchemist/errors/transmutation_error'
require_relative 'alchemist/errors/guard_failure'
require_relative 'alchemist/errors/invalid_transmutation_method'
require_relative 'alchemist/errors/no_target_received'
require_relative 'alchemist/errors/invalid_result_method_for_transfer'
require_relative 'alchemist/errors/invalid_source_method'

module Alchemist
  extend self

  def transmute(source_object, result_type, trait=nil)
    transmutation = Transmutation.new(source_object, result_type, trait)
    transmutation.process
    transmutation.result
  end

end
