class CreateFavs < ActiveRecord::Migration
  def change
    create_table :favs do |t|
      t.integer :user_id
      t.integer :wifi_location_id
    end
  end
end
