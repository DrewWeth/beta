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

ActiveRecord::Schema.define(version: 20150103083655) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "devices", force: true do |t|
    t.string   "auth_key"
    t.string   "parse_token"
    t.string   "profile_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", force: true do |t|
    t.string   "content",                                                             default: ""
    t.spatial  "latlon",     limit: {:srid=>4326, :type=>"point", :geographic=>true}
    t.integer  "views",                                                               default: 0
    t.integer  "ups",                                                                 default: 0
    t.integer  "downs",                                                               default: 0
    t.float    "radius",                                                              default: 2.0
    t.integer  "device_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "address"
    t.string   "city"
  end

  add_index "posts", ["created_at"], :name => "post_created_at_index"
  add_index "posts", ["device_id"], :name => "post_device_foreign_key_index"

end
