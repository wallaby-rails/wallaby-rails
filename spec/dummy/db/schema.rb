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

ActiveRecord::Schema.define(version: 20160316012050) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"
  enable_extension "ltree"
  enable_extension "citext"

  create_table "all_postgres_types", force: :cascade do |t|
    t.string      "string"
    t.text        "text"
    t.integer     "integer"
    t.float       "float"
    t.decimal     "decimal"
    t.datetime    "datetime"
    t.time        "time"
    t.date        "date"
    t.daterange   "daterange"
    t.numrange    "numrange"
    t.tsrange     "tsrange"
    t.tstzrange   "tstzrange"
    t.int4range   "int4range"
    t.int8range   "int8range"
    t.binary      "binary"
    t.boolean     "boolean"
    t.integer     "bigint",      limit: 8
    t.xml         "xml"
    t.tsvector    "tsvector"
    t.hstore      "hstore"
    t.inet        "inet"
    t.cidr        "cidr"
    t.macaddr     "macaddr"
    t.uuid        "uuid"
    t.json        "json"
    t.jsonb       "jsonb"
    t.ltree       "ltree"
    t.citext      "citext"
    t.point       "point"
    t.bit         "bit",         limit: 1
    t.bit_varying "bit_varying"
    t.money       "money",                 scale: 2
  end

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

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
