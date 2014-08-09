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

ActiveRecord::Schema.define(version: 20140809071822) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "games", force: true do |t|
    t.string   "name"
    t.datetime "starts_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "timezone",       default: "America/Los_Angeles"
    t.string   "start_location"
  end

  create_table "registrations", force: true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "email"
    t.boolean  "can_email"
    t.date     "birthday"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "team_name"
    t.boolean  "checked_in",            default: false
    t.integer  "game_id"
    t.string   "token",      limit: 6
    t.text     "user_agent"
    t.string   "ip_address", limit: 12
    t.text     "referrer"
  end

  add_index "registrations", ["game_id", "email"], name: "index_registrations_on_game_id_and_email", using: :btree
  add_index "registrations", ["game_id", "token"], name: "index_registrations_on_game_id_and_token", unique: true, using: :btree
  add_index "registrations", ["user_id"], name: "index_registrations_on_user_id", using: :btree

  create_table "services", force: true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "uname"
    t.string   "uemail"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "services", ["provider", "uid"], name: "index_services_on_provider_and_uid", unique: true, using: :btree
  add_index "services", ["user_id"], name: "index_services_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "referrer"
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree

end
