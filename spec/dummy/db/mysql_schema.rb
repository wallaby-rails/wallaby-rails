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

ActiveRecord::Schema.define(version: 0) do

  create_table "all_mysql_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.binary "binary"
    t.boolean "boolean"
    t.date "date"
    t.datetime "datetime"
    t.decimal "decimal", precision: 10
    t.float "float"
    t.integer "integer"
    t.binary "longblob", limit: 4294967295
    t.text "longtext", limit: 4294967295
    t.binary "mediumblob", limit: 16777215
    t.text "mediumtext", limit: 16777215
    t.string "string"
    t.text "text"
    t.time "time"
    t.text "tinytext", limit: 255
    t.bigint "unsigned_bigint", unsigned: true
    t.decimal "unsigned_decimal", precision: 10, unsigned: true
    t.float "unsigned_float", unsigned: true
    t.integer "unsigned_integer", unsigned: true
    t.binary "blob"
    t.blob "tinyblob", limit: 255
  end

end
