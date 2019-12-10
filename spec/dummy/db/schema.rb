# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 0) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "hstore"
  enable_extension "ltree"
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
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "all_postgres_types", force: :cascade do |t|
    t.bigint "bigint"
    t.binary "binary"
    t.bit "bit", limit: 1
    t.bit_varying "bit_varying"
    t.boolean "boolean"
    t.cidr "cidr"
    t.citext "citext"
    t.string "color"
    t.date "date"
    t.daterange "daterange"
    t.datetime "datetime"
    t.decimal "decimal"
    t.string "email"
    t.float "float"
    t.hstore "hstore"
    t.inet "inet"
    t.int4range "int4range"
    t.int8range "int8range"
    t.integer "integer"
    t.json "json"
    t.jsonb "jsonb"
    t.ltree "ltree"
    t.macaddr "macaddr"
    t.money "money", scale: 2
    t.numrange "numrange"
    t.string "password"
    t.string "string"
    t.text "text"
    t.time "time"
    t.tsrange "tsrange"
    t.tstzrange "tstzrange"
    t.tsvector "tsvector"
    t.uuid "uuid"
    t.xml "xml"
    t.bigserial "bigserial", null: false
    t.box "box"
    t.circle "circle"
    t.line "line"
    t.lseg "lseg"
    t.path "path"
    t.point "point"
    t.polygon "polygon"
    t.serial "serial", null: false
  end

  create_table "blogs", force: :cascade do |t|
    t.string "author"
    t.string "subject"
    t.string "summary"
    t.string "image"
    t.text "body"
    t.datetime "published_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
  end

  create_table "order_items", force: :cascade do |t|
    t.integer "order_id"
    t.integer "product_id"
    t.integer "quantity"
    t.float "price"
    t.float "total"
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["product_id"], name: "index_order_items_on_product_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "customer"
    t.datetime "ordered_at"
  end

  create_table "people", force: :cascade do |t|
    t.string "type"
  end

  create_table "pictures", force: :cascade do |t|
    t.string "name"
    t.integer "imageable_id"
    t.string "imageable_type"
    t.binary "file"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["imageable_type", "imageable_id"], name: "index_pictures_on_imageable_type_and_imageable_id"
  end

  create_table "product_details", force: :cascade do |t|
    t.integer "product_id"
    t.text "meta_data"
    t.index ["product_id"], name: "index_product_details_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.integer "category_id"
    t.string "sku"
    t.string "name"
    t.text "description"
    t.integer "stock"
    t.float "price"
    t.boolean "featured"
    t.date "available_to_date"
    t.time "available_to_time"
    t.datetime "published_at"
    t.index ["category_id"], name: "index_products_on_category_id"
  end

  create_table "products_tags", id: false, force: :cascade do |t|
    t.integer "product_id", null: false
    t.integer "tag_id", null: false
    t.index ["product_id", "tag_id"], name: "index_products_tags_on_product_id_and_tag_id", unique: true
    t.index ["product_id"], name: "index_products_tags_on_product_id"
    t.index ["tag_id"], name: "index_products_tags_on_tag_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
  end

  create_table "things", force: :cascade do |t|
    t.string "sti_type"
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

end
