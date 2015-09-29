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

ActiveRecord::Schema.define(version: 20150928100629) do

  create_table "categories", force: :cascade do |t|
    t.string "name"
  end

  create_table "products", force: :cascade do |t|
    t.integer  "category_id"
    t.string   "sku"
    t.string   "name"
    t.text     "description"
    t.integer  "stock"
    t.float    "price"
    t.boolean  "featured"
    t.date     "available_to_date"
    t.time     "available_to_time"
    t.datetime "published_at"
  end

  create_table "products_tags", id: false, force: :cascade do |t|
    t.integer "tag_id"
    t.integer "product_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
  end

end
