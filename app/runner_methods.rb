module Runner

  class IpAddress
    def self.set_coords_based_on_ip(wifi_runner)
      wifi_runner.latitude = wifi_runner.user.lat
      wifi_runner.longitude = wifi_runner.user.lon
    end
  end

  class StreetAddress

    def self.prompt_address
      puts 'please enter an address'
      gets.strip
    end

    def self.search_google(address, wifi_runner)
      Geocoder::Query.new(address).lookup
      wifi_runner.search_results = Geocoder::Lookup::Google.new.search(address)
    end

    def self.address_to_coords(address, wifi_runner)
      location = self.search_google(address, wifi_runner)[0].data["geometry"]["location"]
      wifi_runner.longitude = location["lng"]
      wifi_runner.latitude = location["lat"]
    end
  end

  class Coordinates
    def self.coords_prompt(wifi_runner)
      puts "Please enter your lat and long like this: lat, long"
      input = gets.strip
      wifi_runner.latitude, wifi_runner.longitude = input.split(", ")
    end

    def self.coords_wifi_finder(wifi_runner)
      distance_hash = HotspotData.hotspots.each_with_object({}) do |wifi, h|
        distance = Geocoder::Calculations.distance_between( [wifi_runner.latitude, wifi_runner.longitude], [wifi.latitude, wifi.longitude] )
        h[wifi.name] = {distance: distance, id: wifi.id}
      end
      closest_wifi = distance_hash.sort_by {|k,v| v[:distance]}[0]
      wifi_runner.closest_wifi = { name: closest_wifi[0], distance: closest_wifi[1][:distance], id: closest_wifi[1][:id] }
    end

    def self.display_wifi_distance( name:, distance:, id: )
      hotspot = HotspotData.hotspots.find(id)
      puts "#{name} located at #{hotspot.location.downcase.gsub(/\b(?<!['’`])[a-z]/) { $&.capitalize }}, is #{distance.round(3)} miles away. When you arrive, you will see it in your list of available connections as '#{hotspot.ssid}'."
    end

    def self.find_closest_wifi(wifi_runner)
      self.coords_wifi_finder(wifi_runner)
      self.display_wifi_distance( wifi_runner.closest_wifi)
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
    def self.favorite(wifi_runner)
      {
        user_id: wifi_runner.user.id,
        wifi_location_id: wifi_runner.closest_wifi[:id]
      }
    end

    def self.add_to_favorites(wifi_runner)
      puts "Would you like to add this wifi location to your Favorites? (y/n)"
      input = ""
      while !(input == "y" || input == "n")
        input = gets.strip.downcase
        if input == "y"
          add_favorites(wifi_runner)
        elsif input == "n"
          false
        else
          puts "Please respond either 'y' or 'n'."
        end
      end
    end

    def self.add_favorites(wifi_runner)
      Fav.find_or_create_by( favorite(wifi_runner) )
    end

    def self.favorite?(wifi_runner)
      !Fav.find_by( favorite(wifi_runner) )
    end

    def self.display_favorites(wifi_runner)
      favorites = wifi_runner.user.favs.map do |fav|
        location = WifiLocation.find(fav.wifi_location_id)
        fav_wifi_info = {
          name: location.name,
          distance: Geocoder::Calculations.distance_between( [wifi_runner.latitude, wifi_runner.longitude], [location.latitude, location.longitude] ),
          id: location.id
        }
      end
      favorites = favorites.sort_by {|fav| fav[:distance] }
      favorites.each_with_index do |fav, i|
        print "#{i + 1}. "
        Runner::Coordinates.display_wifi_distance(fav)
      end
    end
  end

end
