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
      session.set_coords_based_on_ip
      session.find_closest_wifi
    when 'list hotspots'
      WifiRunner.hotspot_areas.each do |area|
        puts area
      end
    when 'by loc'
      session.coords_prompt
      session.find_closest_wifi
    when 'near address'
      address = session.prompt_address
      session.address_to_coords(address)
      session.find_closest_wifi
    end
  end
  puts 'Thank you for using WiFinder. Goodbye.'
end

run
