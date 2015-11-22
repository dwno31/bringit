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

ActiveRecord::Schema.define(version: 20151112093659) do

  create_table "customers", force: :cascade do |t|
    t.string   "customer_simid", limit: 255
    t.string   "customer_payid", limit: 255
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "gcmid",          limit: 255
  end

  create_table "menus", force: :cascade do |t|
    t.integer "menu_price",  limit: 4
    t.integer "shop_id",     limit: 4
    t.string  "menu_title",  limit: 255
    t.integer "hot_cold",    limit: 4
    t.string  "menu_option", limit: 255
    t.integer "caffeine",    limit: 4
    t.float   "menu_order",  limit: 24
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "customer_id",    limit: 4
    t.integer  "shop_id",        limit: 4
    t.datetime "order_time"
    t.boolean  "check_active"
    t.string   "daily_number",   limit: 255
    t.integer  "order_count",    limit: 4
    t.string   "payment_method", limit: 255
    t.text     "order_list",     limit: 65535
    t.boolean  "is_inline"
  end

  create_table "shops", force: :cascade do |t|
    t.string "shop_location", limit: 255
    t.string "shop_name",     limit: 255
    t.string "cafe_img",      limit: 255
    t.string "cafe_phone",    limit: 255
    t.string "shop_loginid",  limit: 255
  end

end
