class WifiRunner
  attr_accessor :latitude, :longitude, :input, :closest_wifi, :search_results
  attr_reader :user, :coordinates, :favorites, :street_address

  def initialize
    puts "Please enter your name:"
    input = gets.strip
    @user = User.find_or_initialize_by(name: input)
    self.user.ip_address = `dig +short myip.opendns.com @resolver1.opendns.com`.chomp
    self.user.save
    puts "Welcome #{self.user.name}!"
    Runner::IpAddress.new(self).set_coords_based_on_ip
    @coordinates = Runner::Coordinates.new(self)
    @favorites = Runner::Favorites.new(self)
    @street_address = Runner::StreetAddress.new(self)
  end

  def self.greeting
    puts 'Welcome to WiFinder'
  end

  def self.help
    puts 'near me         - nearest wifi to my current location'
    puts 'near address    - nearest wifi to a given address'
    puts 'by coordinates  - nearest wifi by location'
    puts 'my favorites    - displays all of your favorites'
    puts 'quit            - exit the program'
  end

  def prompt_user
    puts 'Enter a command below or type \'help\' for a list of commands'
    self.input = gets.strip
  end

  def by_coordinates
    coordinates.coords_prompt
    coordinates.find_closest_wifi
    if favorites.favorite?
      favorites.add_to_favorites
    end
  end

  def near_address
    address = street_address.prompt_address
    street_address.address_to_coords(address)
    coordinates.find_closest_wifi
    if favorites.favorite?
      favorites.add_to_favorites
    end
  end

  def near_me
    coordinates.find_closest_wifi
    if favorites.favorite?
      favorites.add_to_favorites
    end
  end

  def my_favorites
    favorites.display_favorites
  end

  def delete_favorite
    favorites.display_favorites
    favorites.delete_at
    favorites.display_favorites
  end
end
