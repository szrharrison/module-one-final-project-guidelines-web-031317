# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 3) do

  create_table "favs", force: :cascade do |t|
    t.integer "user_id"
    t.integer "wifi_location_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
  end

  create_table "wifi_locations", force: :cascade do |t|
    t.float    "x"
    t.float    "y"
    t.string   "city"
    t.string   "name"
    t.datetime "activated"
    t.string   "location"
    t.string   "provider"
    t.string   "location_type"
    t.string   "ssid"
    t.integer  "object_id"
    t.integer  "source_id"
    t.string   "borough"
    t.string   "remarks"
    t.string   "access"
    t.float    "longitude"
    t.float    "latitude"
  end

end
