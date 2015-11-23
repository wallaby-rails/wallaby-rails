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

ActiveRecord::Schema.define(version: 20151123030821) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "name"
  end

  create_table "order_items", force: :cascade do |t|
    t.integer "order_id"
    t.integer "product_id"
    t.integer "quantity"
    t.float   "price"
    t.float   "total"
  end

  add_index "order_items", ["order_id"], name: "index_order_items_on_order_id", using: :btree
  add_index "order_items", ["product_id"], name: "index_order_items_on_product_id", using: :btree

  create_table "orders", force: :cascade do |t|
    t.string   "customer"
    t.datetime "ordered_at"
  end

  create_table "pictures", force: :cascade do |t|
    t.string   "name"
    t.integer  "imageable_id"
    t.string   "imageable_type"
    t.binary   "file"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "pictures", ["imageable_id"], name: "index_pictures_on_imageable_id", using: :btree

  create_table "product_details", force: :cascade do |t|
    t.integer "product_id"
    t.text    "meta_data"
  end

  add_index "product_details", ["product_id"], name: "index_product_details_on_product_id", using: :btree

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

  add_index "products", ["category_id"], name: "index_products_on_category_id", using: :btree

  create_table "products_tags", id: false, force: :cascade do |t|
    t.integer "product_id", null: false
    t.integer "tag_id",     null: false
  end

  add_index "products_tags", ["product_id", "tag_id"], name: "index_products_tags_on_product_id_and_tag_id", using: :btree
  add_index "products_tags", ["product_id"], name: "index_products_tags_on_product_id", using: :btree
  add_index "products_tags", ["tag_id"], name: "index_products_tags_on_tag_id", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string "name"
  end

end
