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

  create_table "all_mysql_types", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.binary   "binary",           limit: 65535
    t.boolean  "boolean"
    t.date     "date"
    t.datetime "datetime"
    t.decimal  "decimal",                             precision: 10
    t.float    "float",            limit: 24
    t.integer  "integer"
    t.binary   "longblob",         limit: 4294967295
    t.text     "longtext",         limit: 4294967295
    t.binary   "mediumblob",       limit: 16777215
    t.text     "mediumtext",       limit: 16777215
    t.string   "string"
    t.text     "text",             limit: 65535
    t.time     "time"
    t.text     "tinytext",         limit: 255
    t.bigint   "unsigned_bigint",                                    unsigned: true
    t.decimal  "unsigned_decimal",                    precision: 10, unsigned: true
    t.float    "unsigned_float",   limit: 24,                        unsigned: true
    t.integer  "unsigned_integer",                                   unsigned: true
    if Rails::VERSION::MAJOR >= 5
      t.blob "blob"
      t.tinyblob "tinyblob"
    end
  end

end
