require_relative 'spec_helper'
require 'pry'

USER_TEST_FILE   = 'specs/test_data/users_test.csv'
TRIP_TEST_FILE   = 'specs/test_data/trips_test.csv'
DRIVER_TEST_FILE = 'specs/test_data/drivers_test.csv'

describe "TripDispatcher class" do
  before do
    @dispatcher = RideShare::TripDispatcher.new(
      USER_TEST_FILE,
      DRIVER_TEST_FILE,
      TRIP_TEST_FILE
    )
  end

  xdescribe "Initializer" do
    it "is an instance of TripDispatcher" do
      expect(@dispatcher).must_be_kind_of RideShare::TripDispatcher
    end

    it "establishes the base data structures when instantiated" do
      [:trips, :passengers].each do |prop|
        expect(@dispatcher).must_respond_to prop
      end
      expect(@dispatcher.trips).must_be_kind_of Array
      expect(@dispatcher.passengers).must_be_kind_of Array
      expect(@dispatcher.drivers).must_be_kind_of Array
    end
  end

  xdescribe "find_user method" do
    it "throws an argument error for a bad ID" do
      expect{ @dispatcher.find_passenger(0) }.must_raise ArgumentError
    end

    it "finds a user instance" do
      passenger = @dispatcher.find_passenger(2)
      expect(passenger).must_be_kind_of RideShare::User
    end
  end

  xdescribe "find_driver method" do
    it "throws an argument error for a bad ID" do
      expect { @dispatcher.find_driver(0) }.must_raise ArgumentError
    end

    it "finds a driver instance" do
      driver = @dispatcher.find_driver(2)
      expect(driver).must_be_kind_of RideShare::Driver
    end
  end

  xdescribe "Driver & Trip loader methods" do
    it "accurately loads driver information into drivers array" do

      first_driver = @dispatcher.drivers.first
      last_driver = @dispatcher.drivers.last

      expect(first_driver.name).must_equal "Driver2"
      expect(first_driver.id).must_equal 2
      expect(first_driver.status).must_equal :UNAVAILABLE
      expect(last_driver.name).must_equal "Driver8"
      expect(last_driver.id).must_equal 8
      expect(last_driver.status).must_equal :AVAILABLE
    end

    it "Connects drivers with trips" do
      trips = @dispatcher.trips

      [trips.first, trips.last].each do |trip|
        driver = trip.driver

        expect(driver).must_be_instance_of RideShare::Driver
        expect(driver.driven_trips).must_include trip
      end
    end
  end

  xdescribe "User & Trip loader methods" do
    it "accurately loads passenger information into passengers array" do
      first_passenger = @dispatcher.passengers.first
      last_passenger = @dispatcher.passengers.last

      expect(first_passenger.name).must_equal "User1"
      expect(first_passenger.id).must_equal 1
      expect(last_passenger.name).must_equal "Driver8"
      expect(last_passenger.id).must_equal 8
    end

    it "accurately loads trip info and associates trips with passengers" do
      trip = @dispatcher.trips.first
      passenger = trip.passenger

      expect(passenger).must_be_instance_of RideShare::User
      expect(passenger.trips).must_include trip
    end
  end

  describe '#request_trip method' do
    before do
      @requested_trip = @dispatcher.request_trip(1)
    end

    xit "Assigns the first :AVAILABLE driver to a new Trip" do
      driver  = @requested_trip.driver
      expect(driver).must_be_instance_of RideShare::Driver
    end

    xit "uses the current time as @start_time for new Trip" do
      start_time = @requested_trip.start_time
      expect(start_time).must_be_instance_of Time
    end

    xit "Adds new Trip to collection of all Trips in TripDispatcher" do
      expect(@dispatcher.trips.last).must_equal @requested_trip
    end

    it "Does not assign a driver with same ID as passenger" do
      new_trip = @dispatcher.request_trip(5)
      driver_id = new_trip.driver.id
      passenger_id = new_trip.passenger.id

      expect(driver_id).wont_equal passenger_id
      expect(driver_id).must_equal 8
    end

    it "Raises an error if there are no :AVAILABLE drivers" do

    end
  end
end
