class User < ActiveRecord::Base
  extend Geocoder::Model::ActiveRecord

  attr_accessor :lat, :lon

  def find_user_ip
    ip_address = `dig +short myip.opendns.com @resolver1.opendns.com`.chomp
    self.update(ip_address: ip_address)
  end

  geocoded_by :ip_address,
    :latitude => :lat, :longitude => :lon
  after_update :geocode
end
