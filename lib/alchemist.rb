require_relative 'travel_agent/trip'

require_relative 'travel_agent/errors/invalid_translation_method'

module TravelAgent
  extend self
  
  def trip(traveller, result_type)
    trip = Trip.new(traveller, result_type)
    trip.pack
  end

end
