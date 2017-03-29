class Adapters::NYCOpenData
  CLIENT = SODA::Client.new( {:domain => "data.cityofnewyork.us", :app_token => "SkXn4kiHy73Tpm0xjTrcD29My"} )

  def self.client
    CLIENT
  end

  def self.seed_wifi_locations
    wifi_location_data.each do |data|
      get_wifi_location( data )
    end
  end

  private

  def self.wifi_location_data
    response = client.get( "jd4g-ks2z" )
  end

  def self.get_wifi_location( data )
    location = {
      longitude:      data["the_geom"]["coordinates"][0],
      latitude:       data["the_geom"]["coordinates"][1]
    }
    attributes = {
      x:              data["x"],
      y:              data["y"],
      city:           data["city"],
      name:           data["name"],
      activated:      data["activated"],
      location:       data["location"],
      provider:       data["provider"],
      location_type:  data["location_t"],
      ssid:           data["ssid"],
      object_id:      data["objectid"],
      source_id:      data["sourceid"],
      borough:        data["boro"],
      remarks:        data["remarks"],
      access:         data["type"],
    }
    WifiLocation.create_with(attributes).find_or_create_by(location)
  end
end
