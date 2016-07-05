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

ActiveRecord::Schema.define(version: 20160630121842) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admin", force: :cascade do |t|
    t.string "product_slug", default: "products", null: false
  end

  create_table "products", force: :cascade do |t|
    t.string "sku", null: false
  end

  add_index "products", ["sku"], name: "index_products_on_sku", unique: true, using: :btree

  create_table "slugs", force: :cascade do |t|
    t.integer  "resource_id",                  null: false
    t.string   "resource_type",                null: false
    t.boolean  "active",        default: true, null: false
    t.string   "slug_prefix",   default: "",   null: false
    t.string   "slug",                         null: false
    t.string   "computed_slug",                null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "slugs", ["computed_slug"], name: "index_slugs_on_computed_slug", using: :btree
  add_index "slugs", ["resource_type", "resource_id"], name: "index_slugs_on_resource_type_and_resource_id", using: :btree

end
