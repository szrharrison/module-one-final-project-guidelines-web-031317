require_relative '../config/environment'

def run
  greeting
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
    end
  end
  puts 'Thank you for using WiFinder. Goodbye.'
end

run
