require_relative '../config/environment'

def run
  greeting
  user = start_user_session
  welcome_user(user)
  input = ''
  while input != 'quit'
    input = prompt_user
    case input
    when 'help'
      help
    when 'list hotspots'
      hotspot_areas.each do |area|
        puts area
      end
    when 'wifi by loc'
      loc = loc_prompt
      loc_wifi_finder(loc)
    end
  end
  puts 'Thank you for using WiFinder. Goodbye.'
end

run
