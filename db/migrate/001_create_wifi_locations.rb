class CreateWifiLocations < ActiveRecord::Migration
  def change
    create_table :wifi_locations do |t|
      t.float :x
      t.float :y
      t.string :city
      t.string :name
      t.datetime :activated
      t.string :location
      t.string :provider
      t.string :location_type
      t.string :ssid
      t.integer :object_id
      t.integer :source_id
      t.string :borough
      t.string :remarks
      t.string :type
      t.float :longitude # ['geometry']['coordinates'][0]
      t.float :latitude # ['geometry']['coordinates'][1]
    end
  end
end
