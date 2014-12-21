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

ActiveRecord::Schema.define(version: 20141214192231) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "matches", force: true do |t|
    t.string "type"
    t.string "status"
    t.jsonb  "state"
  end

  add_index "matches", ["state"], name: "index_matches_on_state", using: :gin
  add_index "matches", ["status"], name: "index_matches_on_status", using: :btree
  add_index "matches", ["type"], name: "index_matches_on_type", using: :btree

  create_table "participants", force: true do |t|
    t.integer "match_id"
    t.integer "player_id"
    t.integer "seat"
    t.float   "score"
    t.integer "rank"
  end

  add_index "participants", ["match_id"], name: "index_participants_on_match_id", using: :btree
  add_index "participants", ["player_id"], name: "index_participants_on_player_id", using: :btree
  add_index "participants", ["rank"], name: "index_participants_on_rank", using: :btree
  add_index "participants", ["score"], name: "index_participants_on_score", using: :btree
  add_index "participants", ["seat"], name: "index_participants_on_seat", using: :btree

  create_table "players", force: true do |t|
    t.string   "type"
    t.integer  "user_id"
    t.string   "name"
    t.string   "url",                         null: false
    t.string   "game",                        null: false
    t.float    "rating",     default: 2000.0
    t.boolean  "active",     default: true
    t.integer  "warnings",   default: 0
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "players", ["active"], name: "index_players_on_active", using: :btree
  add_index "players", ["game"], name: "index_players_on_game", using: :btree
  add_index "players", ["user_id"], name: "index_players_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string "username"
    t.string "email"
    t.string "password_digest"
    t.string "confirmation_token"
    t.string "confirmed_at"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
