class User < ActiveRecord::Base
  extend Geocoder::Model::ActiveRecord

  has_many :favs
  has_many :wifi_locations, through: :favs

  attr_accessor :lat, :lon, :ip_address

  geocoded_by :ip_address,
    :latitude => :lat, :longitude => :lon
  after_save :geocode
end
