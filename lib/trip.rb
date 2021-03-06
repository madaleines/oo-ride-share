require 'csv'

module RideShare
  class Trip
    attr_reader :id, :driver, :passenger, :start_time, :end_time, :cost, :rating

    def initialize(input)
      @id = input[:id]
      @driver = input[:driver]
      @passenger = input[:passenger]
      @start_time = input[:start_time]
      @end_time = input[:end_time]
      @cost = input[:cost]
      @rating = input[:rating]

      raise ArgumentError.new("Invalid rating #{@rating}") if @rating != nil && (@rating > 5 || @rating < 1)

      raise ArgumentError.new("Start time cannot be greater than End time") if @end_time != nil && (@end_time < @start_time)
    end

    def inspect
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)} " +
      "ID=#{id.inspect} " +
      "PassengerID=#{passenger&.id.inspect}>"
    end

    def duration
      return @end_time - @start_time
    end
  end
end
