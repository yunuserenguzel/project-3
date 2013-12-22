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

ActiveRecord::Schema.define(version: 20131127172131) do

  create_table "authentications", force: true do |t|
    t.string   "token"
    t.integer  "user"
    t.string   "platform"
    t.string   "push_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "follows", force: true do |t|
    t.integer  "follower"
    t.integer  "followed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "likes", force: true do |t|
    t.integer  "sonic_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notifications", force: true do |t|
    t.integer  "user_id"
    t.string   "notification_type"
    t.string   "data"
    t.boolean  "is_read"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "registration_requests", force: true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "passhash"
    t.string   "validation_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "registration_requests", ["email"], name: "index_registration_requests_on_email", unique: true
  add_index "registration_requests", ["username"], name: "index_registration_requests_on_username", unique: true

  create_table "sonics", force: true do |t|
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "is_private"
    t.integer  "user"
    t.integer  "likes_count"
    t.integer  "comments_count"
    t.integer  "resonics_count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "sonic_data_file_name"
    t.string   "sonic_data_content_type"
    t.integer  "sonic_data_file_size"
    t.datetime "sonic_data_updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "passhash"
    t.string   "realname"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "profile_image_file_name"
    t.string   "profile_image_content_type"
    t.integer  "profile_image_file_size"
    t.datetime "profile_image_updated_at"
  end

end
