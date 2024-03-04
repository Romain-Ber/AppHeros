# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_03_04_162656) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bars", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.float "latitude"
    t.float "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
  end

  create_table "challenges", force: :cascade do |t|
    t.bigint "bar_id", null: false
    t.string "location"
    t.string "status"
    t.float "winner_score"
    t.float "loser_score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "from_id"
    t.bigint "to_id"
    t.bigint "winner_id"
    t.bigint "loser_id"
    t.index ["bar_id"], name: "index_challenges_on_bar_id"
    t.index ["from_id"], name: "index_challenges_on_from_id"
    t.index ["loser_id"], name: "index_challenges_on_loser_id"
    t.index ["to_id"], name: "index_challenges_on_to_id"
    t.index ["winner_id"], name: "index_challenges_on_winner_id"
  end

  create_table "scores", force: :cascade do |t|
    t.bigint "bar_id", null: false
    t.bigint "user_id", null: false
    t.float "score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bar_id"], name: "index_scores_on_bar_id"
    t.index ["user_id"], name: "index_scores_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.integer "age"
    t.float "latitude"
    t.float "longitude"
    t.text "description"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "challenges", "bars"
  add_foreign_key "challenges", "users", column: "from_id"
  add_foreign_key "challenges", "users", column: "loser_id"
  add_foreign_key "challenges", "users", column: "to_id"
  add_foreign_key "challenges", "users", column: "winner_id"
  add_foreign_key "scores", "bars"
  add_foreign_key "scores", "users"
end
