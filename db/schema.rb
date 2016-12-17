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

ActiveRecord::Schema.define(version: 20161125180002) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_executives", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "admins", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "feed_sources", force: :cascade do |t|
    t.string   "url",        null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "feeds", force: :cascade do |t|
    t.text     "raw_xml",        null: false
    t.string   "xpaths",         null: false, array: true
    t.integer  "feed_source_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["feed_source_id"], name: "index_feeds_on_feed_source_id", using: :btree
  end

  create_table "field_path_mappings", force: :cascade do |t|
    t.string   "marketing_name"
    t.string   "website"
    t.string   "description"
    t.string   "contact_phone"
    t.string   "contact_email"
    t.string   "street"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "latitude"
    t.string   "longitude"
    t.string   "floorplan_name"
    t.string   "floorplan_square_feet"
    t.string   "floorplan_market_rent"
    t.string   "floorplan_effective_rent"
    t.string   "floorplan_bedrooms"
    t.string   "floorplan_bathrooms"
    t.string   "floorplan_availability"
    t.string   "file_floorplan"
    t.string   "file_property"
    t.string   "amenities"
    t.string   "amenities_community"
    t.string   "amenities_floorplan"
    t.string   "pet_dog"
    t.string   "pet_cat"
    t.json     "example_data"
    t.integer  "feed_source_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["feed_source_id"], name: "index_field_path_mappings_on_feed_source_id", using: :btree
  end

  create_table "floorplans", force: :cascade do |t|
    t.string   "name"
    t.json     "square_feet"
    t.json     "market_rent"
    t.json     "effective_rent"
    t.integer  "bedrooms"
    t.integer  "bathrooms"
    t.integer  "availability"
    t.integer  "property_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["property_id"], name: "index_floorplans_on_property_id", using: :btree
  end

  create_table "identities", force: :cascade do |t|
    t.string   "backend_user_type"
    t.integer  "backend_user_id"
    t.integer  "user_id"
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
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["backend_user_type", "backend_user_id"], name: "index_identities_on_backend_user_type_and_backend_user_id", using: :btree
    t.index ["confirmation_token"], name: "index_identities_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_identities_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_identities_on_reset_password_token", unique: true, using: :btree
    t.index ["user_id"], name: "index_identities_on_user_id", using: :btree
  end

  create_table "management_clients", force: :cascade do |t|
    t.string   "name"
    t.integer  "account_executive_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.index ["account_executive_id"], name: "index_management_clients_on_account_executive_id", using: :btree
  end

  create_table "properties", force: :cascade do |t|
    t.string   "marketing_name"
    t.string   "website"
    t.text     "description"
    t.string   "contact_email"
    t.string   "contact_phone"
    t.string   "street"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.float    "latitude"
    t.float    "longitude"
    t.json     "pet_dog"
    t.json     "pet_cat"
    t.json     "amenities"
    t.integer  "feed_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["feed_id"], name: "index_properties_on_feed_id", using: :btree
  end

  create_table "property_clients", force: :cascade do |t|
    t.string   "name"
    t.integer  "account_executive_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.index ["account_executive_id"], name: "index_property_clients_on_account_executive_id", using: :btree
  end

  create_table "social_profiles", force: :cascade do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "nickname"
    t.string   "email"
    t.string   "url"
    t.string   "image_url"
    t.string   "description"
    t.text     "others"
    t.text     "credentials"
    t.text     "raw_info"
    t.integer  "identity_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["identity_id"], name: "index_social_profiles_on_identity_id", using: :btree
    t.index ["provider", "uid"], name: "index_social_profiles_on_provider_and_uid", unique: true, using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "feeds", "feed_sources"
  add_foreign_key "field_path_mappings", "feed_sources"
end
