class WifiRunner
  attr_accessor :latitude, :longitude, :input, :closest_wifi, :search_results
  attr_reader :user

  def initialize
    puts "Please enter your name:"
    input = gets.strip
    @user = User.find_or_initialize_by(name: input)
    self.user.ip_address = `dig +short myip.opendns.com @resolver1.opendns.com`.chomp
    self.user.save
    puts "Welcome #{self.user.name}!"
  end

  def self.greeting
    puts 'Welcome to WiFinder'
  end

  def self.help
    puts 'near me        - nearest wifi to my current location'
    puts 'near address   - nearest wifi to a given address'
    puts 'by loc         - nearest wifi by location'
    puts 'list hotspots  - lists all hotspots'
    puts 'quit           - exit the program'
  end

  def self.hotspots
    WifiLocation.all
  end

  def self.borough_hotspots( borough )

  end

  def self.hotspot_areas
    locations = WifiLocation.pluck(:name)
    locations.uniq.select do |name|
      !( name =~ /-..-/ || name =~ /\A\d+\Z/ ) && name
    end.sort
  end

  def search_google(address)
    Geocoder::Query.new(address).lookup
    self.search_results = Geocoder::Lookup::Google.new.search(address)
  end

  def prompt_user
    puts 'Enter a command below or type \'help\' for a list of commands'
    self.input = gets.strip
  end

  def coords_prompt
    puts "Please enter your lat and long like this: lat, long"
    input = gets.strip
    self.latitude, self.longitude = input.split(", ")
  end

  def coords_wifi_finder
    distance_hash = self.class.hotspots.each_with_object({}) do |wifi, h|
      distance = Geocoder::Calculations.distance_between( [self.latitude, self.longitude], [wifi.latitude, wifi.longitude] )
      h[wifi.name] = distance
    end
    closest_wifi = distance_hash.sort_by {|k,v| v}[0]
    self.closest_wifi = { name: closest_wifi[0], distance: closest_wifi[1] }
  end

  def display_wifi_distance( name:, distance: )
    puts "#{name} located at #{self.class.hotspots.find_by(name: name).location}, is #{distance.round(3)} miles away"
  end

  def find_closest_wifi
    self.coords_wifi_finder
    self.display_wifi_distance( self.closest_wifi )
  end

  def set_coords_based_on_ip
    self.latitude = self.user.lat
    self.longitude = self.user.lon
  end

  def prompt_address
    puts 'please enter an address'
    gets.strip
  end

  def address_to_coords(address)
    location = self.search_google(address)[0].data["geometry"]["location"]
    self.longitude = location["lng"]
    self.latitude = location["lat"]
  end

end
