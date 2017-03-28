def greeting
  puts 'Welcome to WiFinder'
end

def help
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
