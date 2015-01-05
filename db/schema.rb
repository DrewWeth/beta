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

ActiveRecord::Schema.define(version: 20150104110644) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "comments", force: true do |t|
    t.string   "comment"
    t.integer  "device_id"
    t.integer  "post_id"
    t.integer  "ups",        default: 0
    t.integer  "downs",      default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["post_id"], :name => "comments_post_id_index"

  create_table "device_posts", force: true do |t|
    t.integer  "device_id"
    t.integer  "post_id"
    t.integer  "action_id",  default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "device_posts", ["device_id"], :name => "device_id_index"
  add_index "device_posts", ["post_id"], :name => "post_id_index"

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
    t.float    "radius",                                                              default: 3219.0
    t.integer  "device_id"
    t.string   "post_url"
    t.integer  "constraint",                                                          default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "address"
    t.string   "city"
  end

  add_index "posts", ["created_at"], :name => "post_created_at_index"
  add_index "posts", ["device_id"], :name => "post_device_foreign_key_index"

  create_table "reports", force: true do |t|
    t.integer  "device_id"
    t.integer  "post_id"
    t.string   "why"
    t.integer  "action",     default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", force: true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], :name => "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "suggestions", force: true do |t|
    t.integer  "device_id"
    t.integer  "user_id"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "updates", force: true do |t|
    t.string   "message"
    t.boolean  "active",     default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "users_roles", id: false, force: true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], :name => "index_users_roles_on_user_id_and_role_id"

end
