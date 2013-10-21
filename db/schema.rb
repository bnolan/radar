# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20131021061825) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "legs", force: true do |t|
    t.string   "city_path"
    t.float    "latitude"
    t.float    "longitude"
    t.date     "arrival"
    t.integer  "user_id"
    t.integer  "trip_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.spatial  "location",   limit: {:srid=>4326, :type=>"point", :geographic=>true}
  end

  create_table "trips", force: true do |t|
    t.text     "notes"
    t.date     "start"
    t.date     "finish"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "distance"
  end

  create_table "users", force: true do |t|
    t.string   "nickname"
    t.string   "name"
    t.string   "image"
    t.text     "credentials"
    t.integer  "friend_ids",  limit: 8,                                                array: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.spatial  "location",    limit: {:srid=>4326, :type=>"point", :geographic=>true}
    t.string   "city_path"
    t.string   "email"
    t.integer  "uid",         limit: 8
  end

end
