class WifiRunner
  attr_accessor :latitude, :longitude, :input, :closest_wifi, :search_results
  attr_reader :user, :coordinates, :favorites, :street_address

  def initialize
    puts "Please enter your name:"
    self.input = gets.strip
    unless self.input == 'quit'
      @user = User.find_or_initialize_by(name: input)
      self.user.ip_address = `dig +short myip.opendns.com @resolver1.opendns.com`.strip
      self.user.save
      puts "Welcome #{self.user.name}!"
      Runner::IpAddress.new(self).set_coords_based_on_ip
      @coordinates = Runner::Coordinates.new(self)
      @favorites = Runner::Favorites.new(self)
      @street_address = Runner::StreetAddress.new(self)
    end
  end

  def self.greeting
    self.intro_animation
    puts 'Welcome to WiFinder'
  end

  def self.intro_animation
    2.times do
      i = 27
      while i < 96
        print "\033[2J"
        File.foreach("ascii_animation/#{i}.rb") { |f| puts f }
        sleep(0.03)
        i += 1
      end
    end
    i = 27
    while i < 65
      print "\033[2J"
      File.foreach("ascii_animation/#{i}.rb") { |f| puts f }
      sleep(0.03)
      i += 1
    end
  end

  def self.help
    puts 'near me           - nearest wifi to my current location'
    puts 'near address      - nearest wifi to a given address'
    puts 'near coordinates  - nearest wifi by location'
    puts 'my favorites      - displays all of your favorites'
    puts 'delete favorite   - delete a favorite from your favorites'
    puts 'quit              - exit the program'
  end

  def prompt_user
    puts 'Enter a command below or type \'help\' for a list of commands'
    self.input = gets.strip
  end

  def near_coordinates
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
