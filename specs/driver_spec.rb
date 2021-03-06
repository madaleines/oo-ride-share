require_relative 'spec_helper'

describe "Driver class" do
  before do
    @driver = RideShare::Driver.new(
      id: 54,
      name: "Rogers Bartell IV",
      vin: "1C9EVBRM0YBC564DZ",
      phone: '111-111-1111',
      status: :AVAILABLE
    )

    @passenger = RideShare::User.new(
      id: 1,
      name: "Ada",
      phone: "412-432-7640"
    )

    @trip_1 = RideShare::Trip.new(
      id: 8,
      driver: nil,
      passenger: @driver,
      start_time: Time.parse("2016-08-08"),
      end_time: Time.parse("2016-08-09"),
      cost: 10.25,
      rating: 5
    )

    @trip_2 = RideShare::Trip.new(
      id: 9,
      driver: nil,
      passenger: @driver,
      start_time: Time.parse("2016-08-09"),
      end_time: Time.parse("2016-08-10"),
      cost: 23.45,
      rating: 5
    )

    @trip_3 = RideShare::Trip.new(
      id: 10,
      driver: @driver,
      passenger: nil,
      start_time: Time.parse("2016-08-10"),
      end_time: Time.parse("2016-08-11"),
      cost: 15.75,
      rating: 5
    )

    @trip_4 = RideShare::Trip.new(
      id: 11,
      driver: @driver,
      passenger: nil,
      start_time: Time.parse("2016-08-11"),
      end_time: Time.parse("2016-08-12"),
      cost: 3.42,
      rating: 5
    )

    @trip_5 = RideShare::Trip.new(
      id: 12,
      driver: @driver,
      passenger: nil,
      start_time: Time.parse("2016-08-13"),
      end_time: Time.parse("2016-08-14"),
      cost: 35.50,
      rating: 5
    )
  end

  describe "Driver instantiation" do
    it "is an instance of Driver" do
      expect(@driver).must_be_kind_of RideShare::Driver
    end

    it "throws an argument error with a bad ID value" do
      expect{
        RideShare::Driver.new(
          id: 0,
          name: "George",
          vin: "33133313331333133"
        )
      }.must_raise ArgumentError
    end

    it "throws an argument error with a bad VIN value" do
      expect{
        RideShare::Driver.new(
          id: 100,
          name: "George",
          vin: ""
        )
      }.must_raise ArgumentError
      expect{
        RideShare::Driver.new(
          id: 100,
          name: "George",
          vin: "33133313331333133extranums"
        )
      }.must_raise ArgumentError
    end

    it "sets driven trips to an empty array if not provided" do
      expect(@driver.driven_trips).must_be_kind_of Array
      expect(@driver.driven_trips.length).must_equal 0
    end

    it "is set up for specific attributes and data types" do
      [:id, :name, :vehicle_id, :status, :driven_trips].each do |prop|
        expect(@driver).must_respond_to prop
      end

      expect(@driver.id).must_be_kind_of Integer
      expect(@driver.name).must_be_kind_of String
      expect(@driver.vehicle_id).must_be_kind_of String
      expect(@driver.status).must_be_kind_of Symbol
    end
  end

  describe "add_driven_trip method" do
    it "throws an argument error if trip is not provided" do
      expect{ @driver.add_driven_trip(1) }.must_raise ArgumentError
    end

    it "increases the trip count by one" do
      previous = @driver.driven_trips.length
      @driver.add_driven_trip(@trip_1)
      expect(@driver.driven_trips.length).must_equal previous + 1
    end
  end

  describe "average_rating method" do
    before do
      @driver.add_driven_trip(@trip_1)
    end

    it "returns a float" do
      expect(@driver.average_rating).must_be_kind_of Float
    end

    it "returns a float within range of 1.0 to 5.0" do
      average = @driver.average_rating
      expect(average).must_be :>=, 1.0
      expect(average).must_be :<=, 5.0
    end

    it "returns zero if no driven trips" do
      driver = RideShare::Driver.new(
        id: 54,
        name: "Rogers Bartell IV",
        vin: "1C9EVBRM0YBC564DZ"
      )
      expect(driver.average_rating).must_equal 0
    end

    it "correctly calculates the average rating" do
      expect(@driver.average_rating).must_be_close_to 5.0
    end
  end

  describe "total_revenue" do
    before do
      @driver.add_driven_trip(@trip_1)
      @driver.add_driven_trip(@trip_2)
    end
    it "returns 0 if the driver has made no trips" do
      driver = RideShare::Driver.new(
        id: 54,
        name: "Rogers Bartell IV",
        vin: "1C9EVBRM0YBC564DZ"
      )
      expect(driver.total_revenue).must_equal 0
    end
    it "returns the total revenue a driver has made" do
      expect(@driver.total_revenue).must_equal 24.32
    end
  end

  describe "net_expenditures" do
    before do
      @driver.add_trip(@trip_1)
      @driver.add_trip(@trip_2)
      @driver.add_driven_trip(@trip_3)
      @driver.add_driven_trip(@trip_4)
    end

    it 'calculates the total expenditures by a Driver' do
      expect(@driver.net_expenditures).must_equal 21.00
    end

    it 'returns a negative number when total revenue is greater than gross expenditures' do
      @driver.add_driven_trip(@trip_5)
      expect(@driver.net_expenditures).must_equal -6.08
    end
  end

  describe "add_in_progress_trip method" do
    before do
      @dispatcher = RideShare::TripDispatcher.new
      @new_trip = @dispatcher.request_trip(1)
      @driven_trips = @new_trip.driver.driven_trips
      @status = @new_trip.driver.status
    end

    it "adds new in progress trip from TripDispatcher#request_trip to driver's collection of trips" do
      expect(@driven_trips.include?(@new_trip)).must_equal true
    end

    it "sets driver's status to :UNAVAILABLE" do
      expect(@status).must_equal :UNAVAILABLE
    end
  end
end
