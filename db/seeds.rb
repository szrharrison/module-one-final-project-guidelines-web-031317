require_relative '../config/environment.rb'

wifi = File.read('NYC_Wi-Fi_hotspot_locations.geojson')
wifi_hash = JSON.parse(wifi)

wifi_hash["features"].each do |feature|
  args = {
    x:              feature["properties"]["x"],
    y:              feature["properties"]["y"],
    city:           feature["properties"]["city"],
    name:           feature["properties"]["name"],
    activated:      feature["properties"]["activated"],
    location:       feature["properties"]["location"],
    provider:       feature["properties"]["provider"],
    location_type:  feature["properties"]["location_t"],
    ssid:           feature["properties"]["ssid"],
    object_id:      feature["properties"]["objectid"],
    source_id:      feature["properties"]["sourceid"],
    borough:        feature["properties"]["boro"],
    remarks:        feature["properties"]["remarks"],
    access:         feature["properties"]["type"],
    longitude:      feature["geometry"]["coordinates"][0],
    latitude:       feature["geometry"]["coordinates"][1]
  }
  WifiLocation.create(args)
end

# binding.pry
#
# puts hooray!
