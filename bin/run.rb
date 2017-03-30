require_relative '../config/environment'

def run
  WifiRunner.greeting
  session = WifiRunner.new
  while session.input != 'quit'
    session.prompt_user
    case session.input
    when 'help'
      WifiRunner.help
    when 'near me'
      session.near_me
    when 'by coordinates'
      session.by_coordinates
    when 'near address'
      session.near_address
    when 'my favorites'
      session.my_favorites
    end
  end
  puts 'Thank you for using WiFinder. Goodbye.'
end

run
