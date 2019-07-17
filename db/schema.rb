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

ActiveRecord::Schema.define(version: 20190717122443) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "external_freight_rates", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "locations", force: :cascade do |t|
    t.text     "port_id"
    t.string   "display_name"
    t.integer  "postal_code"
    t.text     "loc"
    t.string   "country_code"
    t.string   "name"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "organizations", force: :cascade do |t|
    t.text     "organization_id"
    t.string   "business_name"
    t.string   "description"
    t.text     "city_id"
    t.text     "country_id"
    t.text     "office_city_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",                        null: false
    t.bigint   "aadhar_num",                  null: false
    t.bigint   "contact_num",                 null: false
    t.string   "email_id",                    null: false
    t.string   "city",                        null: false
    t.string   "country",                     null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "password"
    t.boolean  "verified",    default: false
    t.boolean  "boolean",     default: false
  end

end
