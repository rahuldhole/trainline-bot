
# https://www.thetrainline.com/api/journey-search/

class ComTheTrainLine
  attr_accessor :from, :to
  attr_accessor :departure_at #journeyDate.time
  
  def self.find(from, to, departure_at)
    begin
      cttl = ComTheTrainLine.new
      cttl.bot(from, to, departure_at)
    rescue => e
      return puts "Error: #{e.message}. Please try again later. Exiting...".colorize(:red)
    end
  end

  def initialize
    # Locations Search
    @locations_search_url = "https://www.thetrainline.com/api/locations-search/v2/search"
    @searchTerm = ""
    @locale = "en-US"
    @connections = []
    @limit = 30
    set_fixed_locations_search_data

    # Journey Search
    @passengers = []
    @isEurope = false
    @cards = []
    @transitDefinitions = []
    @type = ""
    @maximumJourneys = 0
    @includeRealtime = false
    @transportModes = []
    @directSearch = false
    @composition = false
    set_dummy_journey_search_data

    @spinners = TTY::Spinner::Multi.new("[:spinner] The Trainline jounrey search bot is running...")
    @spinner1 = nil
    @spinner2 = nil
    @spinner3 = nil
  end

  def journey_search_json
    {
      passengers: @passengers,
      isEurope: @isEurope,
      cards: @cards,
      transitDefinitions: @transitDefinitions,
      type: @type,
      maximumJourneys: @maximumJourneys,
      includeRealtime: @includeRealtime,
      transportModes: @transportModes,
      directSearch: @directSearch,
      composition: @composition
    }.to_json
  end

  def bot(from, to, departure_at)
    validate_input(from, to, departure_at)
    departure_at = departure_at.to_time.strftime("%Y-%m-%dT%H:%M:%S")

    from_location_search_params = to_location_search_params(from)
    to_location_search_params = to_location_search_params(to)

    # puts "Searching for #{from} locations...".colorize(:yellow)
    @spinner1 = @spinners.register("[:spinner] Searching for #{from} locations...")
    @spinner1.auto_spin
    from_location_search_response = ApiScrapper.make_plain_get_request(@locations_search_url, from_location_search_params, @spinner1)
    captures(from_location_search_response, "#{from}_locations")
    from_locations = JSON.parse(from_location_search_response)["searchLocations"]
    origin = from_locations.first["code"] # first location for any location
    @spinner1.success


    # puts "Searching for #{to} locations...".colorize(:yellow)
    @spinner2 = @spinners.register("[:spinner] Searching for #{to} locations...")
    @spinner2.auto_spin
    to_location_search_response = ApiScrapper.make_plain_get_request(@locations_search_url, to_location_search_params, @spinner2)
    captures(to_location_search_response, "#{to}_locations")
    to_locations = JSON.parse(to_location_search_response)["searchLocations"]
    destination = to_locations.first["code"]
    @spinner2.success

    set_transit_definition(origin, destination, departure_at)

    # puts "Searching for journeys...".colorize(:yellow)
    @spinner3 = @spinners.register("[:spinner] Searching for journeys from #{from} to #{to} at #{departure_at}...")
    @spinner3.auto_spin
    journey_search_response = ApiScrapper.journey_search(journey_search_json, @spinners, @spinner3)
    @spinner3.success
    captures(journey_search_response, "#{from}_to_#{to}_at_#{departure_at.gsub(":", "-")}_journeys")
  rescue => e
    puts "Error: #{e.message}. Please try again later. Exiting...".colorize(:red)
    return nil
  end

  def captures(data, name=nil)
    return if data.nil?

    name ||= "capture_#{Time.now.to_i}"
    FileUtils.mkdir_p("tmp/captures") unless File.directory?("tmp/captures")
    File.open("tmp/captures/#{name}.json", "w") do |f|
      f.write(data)
    end
    puts "Saved: tmp/captures/#{name}.json".colorize(:green)
  end

  private

  def to_location_search_params(searchTerm)
    @searchTerm = searchTerm
    ["searchTerm=#{@searchTerm}", "locale=#{@locale}", @connections.join("&"), "limit=#{@limit}"].join("&")
  end
  

  protected

  def set_fixed_locations_search_data
    @searchTerm = "" # only this is variable
    @locale = "en-US"
    @limit = 30

    @connections << "connections=urn%3Atrainline%3Aconnection%3Aatoc"
    @connections << "connections=urn%3Atrainline%3Aconnection%3Abenerail"
    @connections << "connections=urn%3Atrainline%3Aconnection%3Abusbud"
    @connections << "connections=urn%3Atrainline%3Aconnection%3Abusbud_affiliate"
    @connections << "connections=urn%3Atrainline%3Aconnection%3Acff"
    @connections << "connections=urn%3Atrainline%3Aconnection%3Adb"
    @connections << "connections=urn%3Atrainline%3Aconnection%3Adb_pst"
    @connections << "connections=urn%3Atrainline%3Aconnection%3Adistribusion"
    @connections << "connections=urn%3Atrainline%3Aconnection%3Aflixbus_affiliate"
    @connections << "connections=urn%3Atrainline%3Aconnection%3Antv"
    @connections << "connections=urn%3Atrainline%3Aconnection%3Aobb"
    @connections << "connections=urn%3Atrainline%3Aconnection%3Apao_ouigo"
    @connections << "connections=urn%3Atrainline%3Aconnection%3Apao_sncf"
    @connections << "connections=urn%3Atrainline%3Aconnection%3Arenfe"
    @connections << "connections=urn%3Atrainline%3Aconnection%3Atrenitalia"
    @connections << "connections=urn%3Atrainline%3Aconnection%3Awestbahn"
    @connections << "connections=urn%3Atrainline%3Aconnection%3Aeurostardirect"
    @connections << "connections=urn%3Atrainline%3Aconnection%3Ailsa"    
  end

  def set_dummy_journey_search_data
    dummy_passenger1 = {
      "id": "efd67d6c-8a28-4ccc-8258-0b59e1ebed69",
      "dateOfBirth": "1990-12-18",
      "cardIds": []
    }
    @passengers << dummy_passenger1
    @isEurope = true
    @cards = []
    @type = "single"
    @maximumJourneys = 5
    @includeRealtime = true
    @transportModes = ["mixed"]
    @directSearch = false
    @composition = ["through", "interchangeSplit"]
  end

  def set_transit_definition(origin, destination, departure_at)
    @transitDefinitions << {
      "direction": "outward",
      "origin": origin,
      "destination": destination,
      "journeyDate": {
        "type": "departAfter",
        "time": departure_at
      }
    }
  end

  def validate_input(from, to, departure_at)
    raise "From location is required" if from.nil?
    raise "To location is required" if to.nil?
    raise "Departure time is required" if departure_at.nil?

    raise "From location must be at least 3 characters long" if from.length < 3
    raise "To location must be at least 3 characters long" if to.length < 3

    raise "Departure time must be in future" if departure_at.to_time <= Time.now
  end
end
