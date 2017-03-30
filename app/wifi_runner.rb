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
    Runner::IpAddress.set_coords_based_on_ip(self)
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
    Runner::Coordinates.coords_prompt(self)
    Runner::Coordinates.find_closest_wifi(self)
    if Runner::Favorites.favorite?(self)
      Runner::Favorites.add_to_favorites(self)
    end
  end

  def near_address
    address = Runner::StreetAddress.prompt_address
    Runner::StreetAddress.address_to_coords(address, self)
    Runner::Coordinates.find_closest_wifi(self)
    if Runner::Favorites.favorite?(self)
      Runner::Favorites.add_to_favorites(self)
    end
  end

  def near_me
    Runner::Coordinates.find_closest_wifi(self)
    if Runner::Favorites.favorite?(self)
      Runner::Favorites.add_to_favorites(self)
    end
  end

  def my_favorites
    Runner::Favorites.display_favorites(self)
  end
end
