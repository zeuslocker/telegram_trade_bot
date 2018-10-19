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

ActiveRecord::Schema.define(version: 20181019064358) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "pay_codes", force: :cascade do |t|
    t.datetime "payed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "term_code"
    t.bigint "site_bot_id"
    t.index ["site_bot_id"], name: "index_pay_codes_on_site_bot_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "title", null: false
    t.float "price", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "desc"
    t.bigint "site_bot_id"
    t.index ["site_bot_id"], name: "index_products_on_site_bot_id"
  end

  create_table "site_bots", force: :cascade do |t|
    t.jsonb "secret_commands", null: false
    t.bigint "site_user_id"
    t.integer "status", default: 0, null: false
    t.float "total_income"
    t.string "easy_number"
    t.string "easy_password"
    t.string "tg_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "last_request_verification_token_for_form"
    t.string "last_cookie"
    t.string "wallet_id", null: false
    t.index ["site_user_id"], name: "index_site_bots_on_site_user_id"
    t.index ["tg_token"], name: "index_site_bots_on_tg_token", unique: true
  end

  create_table "site_users", force: :cascade do |t|
    t.string "username", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "tg_nickname"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reset_password_token"], name: "index_site_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_site_users_on_username", unique: true
  end

  create_table "treasures", force: :cascade do |t|
    t.text "description", null: false
    t.decimal "lat", precision: 10, scale: 6
    t.decimal "lng", precision: 10, scale: 6
    t.bigint "product_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "amount", null: false
    t.integer "location", null: false
    t.integer "status", default: 0
    t.text "file_ids", default: [], array: true
    t.bigint "site_bot_id"
    t.index ["product_id"], name: "index_treasures_on_product_id"
    t.index ["site_bot_id"], name: "index_treasures_on_site_bot_id"
  end

  create_table "users", force: :cascade do |t|
    t.float "balance", default: 0.0, null: false
    t.float "total_order_price", default: 0.0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "choosen_product_id"
    t.integer "choosen_treasure_id"
    t.integer "choosen_location"
    t.datetime "approval_date"
    t.text "allowed_messages", default: [], array: true
    t.datetime "pay_code_lock"
    t.string "telegram_id", null: false
    t.string "first_name"
    t.bigint "site_bot_id"
    t.index ["site_bot_id"], name: "index_users_on_site_bot_id"
    t.index ["telegram_id"], name: "index_users_on_telegram_id"
  end

  add_foreign_key "pay_codes", "site_bots"
  add_foreign_key "products", "site_bots"
  add_foreign_key "site_bots", "site_users"
  add_foreign_key "treasures", "products"
  add_foreign_key "treasures", "site_bots"
  add_foreign_key "users", "site_bots"
end
