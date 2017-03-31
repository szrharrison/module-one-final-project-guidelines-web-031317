module Runner

  class IpAddress
    attr_reader :user, :wifi_runner

    def initialize(wifi_runner)
      @wifi_runner = wifi_runner
      @user = wifi_runner.user
    end

    def set_coords_based_on_ip
      wifi_runner.latitude = user.lat
      wifi_runner.longitude = user.lon
    end
  end

  class StreetAddress
    attr_reader :user, :wifi_runner

    def initialize(wifi_runner)
      @wifi_runner = wifi_runner
      @user = wifi_runner.user
    end

    def prompt_address
      puts 'please enter an address'
      gets.strip
    end

    def search_google(address)
      Geocoder::Query.new(address).lookup
      wifi_runner.search_results = Geocoder::Lookup::Google.new.search(address)
    end

    def address_to_coords(address)
      location = search_google(address)[0].data["geometry"]["location"]
      wifi_runner.longitude = location["lng"]
      wifi_runner.latitude = location["lat"]
    end
  end

  class Coordinates

    attr_reader :user, :wifi_runner

    def initialize(wifi_runner)
      @wifi_runner = wifi_runner
      @user = wifi_runner.user
    end

    def coords_prompt
      puts "Please enter your lat and long like this: lat, long"
      input = gets.strip
      wifi_runner.latitude, wifi_runner.longitude = input.split(", ")
    end

    def coords_wifi_finder
      distance_hash = HotspotData.hotspots.each_with_object({}) do |wifi, h|
        distance = Geocoder::Calculations.distance_between( [wifi_runner.latitude, wifi_runner.longitude], [wifi.latitude, wifi.longitude] )
        h[wifi.name] = {distance: distance, id: wifi.id}
      end
      closest_wifi = distance_hash.sort_by {|k,v| v[:distance]}[0]
      wifi_runner.closest_wifi = { name: closest_wifi[0], distance: closest_wifi[1][:distance], id: closest_wifi[1][:id] }
    end

    def self.display_wifi_distance( name:, distance:, id:, favorite_id: 0)
      hotspot = HotspotData.hotspots.find(id)
      puts "#{name} is located at #{hotspot.location.downcase.gsub(/\b(?<!['’`])[a-z]/) { $&.capitalize }}, is #{distance.round(3)} miles away. When you arrive, you will see it in your list of available connections as '#{hotspot.ssid}'."
    end

    def find_closest_wifi
      coords_wifi_finder
      self.class.display_wifi_distance( wifi_runner.closest_wifi)
    end
  end

  class HotspotData
    def self.hotspots
      WifiLocation.all
    end

    def self.hotspot_areas
      locations = WifiLocation.pluck(:name)
      locations.uniq.select do |name|
        !( name =~ /-..-/ || name =~ /\A\d+\Z/ ) && name
      end.sort
    end
  end

  class Favorites
    attr_accessor :favorites
    attr_reader :user, :wifi_runner

    def initialize(wifi_runner)
      @wifi_runner = wifi_runner
      @user = wifi_runner.user
    end

    def favorite
      {
        user_id: user.id,
        wifi_location_id: wifi_runner.closest_wifi[:id]
      }
    end

    def add_to_favorites
      puts "Would you like to add this wifi location to your Favorites? (y/n)"
      input = ""
      while !(input == "y" || input == "n")
        input = gets.strip.downcase
        if input == "y"
          add_favorites
        elsif input == "n"
          false
        else
          puts "Please respond either 'y' or 'n'."
        end
      end
    end

    def add_favorites
      Fav.find_or_create_by( favorite )
    end

    def favorite?
      !Fav.find_by( favorite )
    end

    def display_favorites
      self.favorites = User.find(user.id).favs.map do |fav|
        location = WifiLocation.find(fav.wifi_location_id)
        fav_wifi_info = {
          name: location.name,
          distance: Geocoder::Calculations.distance_between( [wifi_runner.latitude, wifi_runner.longitude], [location.latitude, location.longitude] ),
          id: location.id,
          favorite_id: fav.id
        }
      end
      self.favorites = favorites.sort_by {|fav| fav[:distance] }
      favorites.each_with_index do |fav, i|
        print "#{i + 1}. "
        Runner::Coordinates.display_wifi_distance(fav)
      end
    end

    def delete_at
      puts "Select favorite to delete by entering its corresponding number."
      fav_to_delete = gets.strip
      id_to_delete = favorites[fav_to_delete.to_i - 1][:favorite_id]
      Fav.find(id_to_delete).destroy
    end

  end

end
