require 'pry'
require_relative 'user'

module RideShare
  class Driver < RideShare::User
    attr_reader :vehicle_id, :driven_trips, :status

    def initialize(input)
      super(input)
      @vehicle_id = input[:vin]
      @driven_trips = input[:driven_trips].nil? ? [] : input[:driven_trips]

      @status = input[:status].nil? ? :AVAILABLE : input[:status]

      raise ArgumentError.new unless [:AVAILABLE, :UNAVAILABLE].include?(@status)

      raise ArgumentError.new unless @vehicle_id.length == 17

    end

    def add_driven_trip(trip)
      raise ArgumentError unless trip.is_a? Trip
      @driven_trips << trip
    end

    def average_rating
      trip_ratings = []
      @driven_trips.each do |trip|
        trip_ratings << trip.rating
      end

      trip_ratings.length == 0 ? 0 : (trip_ratings.sum / trip_ratings.length).to_f
    end

  end
end
