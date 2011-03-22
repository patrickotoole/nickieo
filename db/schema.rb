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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110322184846) do

  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "preferences", :force => true do |t|
    t.integer  "user_id"
    t.integer  "min_price"
    t.integer  "max_price"
    t.integer  "min_sqft"
    t.integer  "max_sqft"
    t.integer  "min_bedrooms"
    t.integer  "max_bedrooms"
    t.integer  "min_bathrooms"
    t.integer  "max_bathroom"
    t.string   "property_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "properties", :force => true do |t|
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.integer  "zipcode"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mls_number"
    t.string   "status"
    t.boolean  "featured"
    t.integer  "price"
    t.text     "description"
    t.text     "headline"
    t.decimal  "lat",            :precision => 16, :scale => 8
    t.decimal  "lng",            :precision => 16, :scale => 8
    t.string   "property_type"
    t.string   "style"
    t.integer  "stories"
    t.string   "occupancy_type"
    t.integer  "floor"
    t.integer  "bedrooms"
    t.decimal  "bathrooms",      :precision => 10, :scale => 1
    t.integer  "sqft"
    t.decimal  "lot",            :precision => 10, :scale => 2
    t.datetime "built"
    t.string   "construction"
    t.string   "garage"
  end

  create_table "property_photos", :force => true do |t|
    t.integer  "property_id"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "picture_type"
    t.integer  "order"
    t.text     "description"
    t.text     "caption"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "password_salt",                       :default => "", :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
