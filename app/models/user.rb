class User < ActiveRecord::Base
  extend Geocoder::Model::ActiveRecord

  attr_accessor :lat, :lon, :ip_address

  geocoded_by :ip_address,
    :latitude => :lat, :longitude => :lon
  after_save :geocode
end
