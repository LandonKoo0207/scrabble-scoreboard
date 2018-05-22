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

ActiveRecord::Schema.define(version: 20180522064700) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "players", force: :cascade do |t|
    t.string "name"
    t.integer "turn"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "scrabble_id"
    t.index ["scrabble_id"], name: "index_players_on_scrabble_id"
  end

  create_table "scrabbles", force: :cascade do |t|
    t.integer "num_of_players"
    t.integer "current_turn"
    t.integer "current_player"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "remaining_letters"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "words", force: :cascade do |t|
    t.string "word"
    t.integer "double_letter", array: true
    t.integer "triple_letter", array: true
    t.boolean "double_word"
    t.boolean "triple_word"
    t.integer "score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "player_id"
    t.integer "existing_letter", array: true
    t.integer "turn"
    t.index ["player_id"], name: "index_words_on_player_id"
  end

  add_foreign_key "players", "scrabbles"
  add_foreign_key "words", "players"
end
