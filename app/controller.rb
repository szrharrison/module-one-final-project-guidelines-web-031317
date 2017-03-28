def greeting
  puts 'Welcome to WiFinder'
end

def help
  puts 'wifi by loc     - nearest wifi by location'
  puts 'list hotspots   - lists all hotspots'
  puts 'quit            - exit the program'
end

def prompt_user
  puts 'Enter a command below or type \'help\' for a list of commands'
  gets.strip
end

def hotspots
  WifiLocation.all
end

def borough_hotspots( borough )

end

def hotspot_areas
  locations = WifiLocation.pluck(:name)
  locations.uniq.select do |name|
    !( name =~ /-..-/ || name =~ /\A\d+\Z/ ) && name
  end.sort
end

def start_user_session
  puts "Please enter your name:"
  input = gets.strip
  User.find_or_create_by(name: input)
end

def welcome_user(user)
  puts "Welcome #{user.name}!"
end

def loc_prompt
  puts "Please enter your lat and long like this: lat, long"
  input = gets.strip
  input.split(", ")
end

def loc_wifi_finder(loc)
  distance_hash = hotspots.each_with_object({}) do |wifi, h|
    distance = Geocoder::Calculations.distance_between( loc, [wifi.latitude, wifi.longitude] )
    h[wifi.name] = distance
  end
  closest_wifi = distance_hash.sort_by {|k,v| v}[0]
  puts "#{closest_wifi[0]} located at #{hotspots.find_by(name: closest_wifi[0]).location}, is #{closest_wifi[1].round(3)} miles away"
end
