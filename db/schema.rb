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

ActiveRecord::Schema[7.1].define(version: 2024_03_14_193022) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "bars", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.float "latitude"
    t.float "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.string "bar_type"
    t.string "opening_hours"
    t.string "phone"
    t.string "outdoor_seats"
    t.string "wheelchair"
    t.string "website"
    t.string "email"
    t.string "image_id"
  end

  create_table "challenges", force: :cascade do |t|
    t.bigint "bar_id", null: false
    t.string "location"
    t.string "status"
    t.float "winner_score"
    t.float "loser_score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "challenger_id"
    t.bigint "challenged_id"
    t.bigint "winner_id"
    t.bigint "loser_id"
    t.bigint "game_id", null: false
    t.index ["bar_id"], name: "index_challenges_on_bar_id"
    t.index ["challenged_id"], name: "index_challenges_on_challenged_id"
    t.index ["challenger_id"], name: "index_challenges_on_challenger_id"
    t.index ["game_id"], name: "index_challenges_on_game_id"
    t.index ["loser_id"], name: "index_challenges_on_loser_id"
    t.index ["winner_id"], name: "index_challenges_on_winner_id"
  end

  create_table "games", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "messages", force: :cascade do |t|
    t.string "content"
    t.bigint "challenge_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["challenge_id"], name: "index_messages_on_challenge_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
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
    t.boolean "first_login"
    t.string "status"
    t.integer "nearest_bar_id"
    t.string "phone"
    t.string "image_id"
    t.string "gender"
    t.integer "score"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "challenges", "bars"
  add_foreign_key "challenges", "games"
  add_foreign_key "challenges", "users", column: "challenged_id"
  add_foreign_key "challenges", "users", column: "challenger_id"
  add_foreign_key "challenges", "users", column: "loser_id"
  add_foreign_key "challenges", "users", column: "winner_id"
  add_foreign_key "messages", "challenges"
  add_foreign_key "messages", "users"
  add_foreign_key "scores", "bars"
  add_foreign_key "scores", "users"
end
