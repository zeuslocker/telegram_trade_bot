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

ActiveRecord::Schema.define(version: 20170917072024) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "products", force: :cascade do |t|
    t.string "title", null: false
    t.float "price", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "treasures", force: :cascade do |t|
    t.text "description", null: false
    t.decimal "lat", precision: 10, scale: 6, null: false
    t.decimal "lng", precision: 10, scale: 6, null: false
    t.bigint "product_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "amount", null: false
    t.integer "location", null: false
    t.index ["product_id"], name: "index_treasures_on_product_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "user_name", null: false
    t.float "balance", default: 0.0, null: false
    t.float "total_order_price", default: 0.0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "choosen_product_id"
    t.integer "choosen_treasure_id"
    t.integer "choosen_location"
    t.index ["user_name"], name: "index_users_on_user_name", unique: true
  end

  add_foreign_key "treasures", "products"
end
