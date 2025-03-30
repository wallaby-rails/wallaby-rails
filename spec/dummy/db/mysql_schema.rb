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

ActiveRecord::Schema[8.0].define(version: 2025_03_30_092312) do
  create_table "all_mysql_types", charset: "utf8mb3", force: :cascade do |t|
    t.binary "binary"
    t.boolean "boolean"
    t.date "date"
    t.datetime "datetime"
    t.decimal "decimal", precision: 10
    t.float "float"
    t.integer "integer"
    t.binary "longblob", size: :long
    t.text "longtext", size: :long
    t.binary "mediumblob", size: :medium
    t.text "mediumtext", size: :medium
    t.string "string"
    t.text "text"
    t.time "time"
    t.text "tinytext", size: :tiny
    t.bigint "unsigned_bigint", unsigned: true
    t.decimal "unsigned_decimal", precision: 10, unsigned: true
    t.float "unsigned_float", unsigned: true
    t.integer "unsigned_integer", unsigned: true
    t.binary "blob"
    t.binary "tinyblob", size: :tiny
  end
end
