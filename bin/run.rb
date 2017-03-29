require_relative '../config/environment'

def run
  WifiRunner.greeting
  session = WifiRunner.new
  while session.input != 'quit'
    session.prompt_user
    case session.input
    when 'help'
      WifiRunner.help
    when 'wifi near me'
      session.set_coords_based_on_ip
      session.coords_wifi_finder
      session.display_wifi_distance( session.closest_wifi )
    when 'list hotspots'
      WifiRunner.hotspot_areas.each do |area|
        puts area
      end
    when 'wifi by loc'
      session.coords_prompt
      session.coords_wifi_finder
      session.display_wifi_distance( session.closest_wifi )
    end
  end
  puts 'Thank you for using WiFinder. Goodbye.'
end

run
