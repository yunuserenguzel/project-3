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

ActiveRecord::Schema.define(version: 20140506171151) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authentications", force: true do |t|
    t.string   "token"
    t.integer  "user_id",    limit: 8
    t.string   "platform"
    t.string   "push_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "authentications", ["token"], name: "index_authentications_on_token", using: :btree

  create_table "comments", force: true do |t|
    t.integer  "sonic_id",   limit: 8
    t.integer  "user_id",    limit: 8
    t.string   "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["sonic_id"], name: "index_comments_on_sonic_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "emails", force: true do |t|
    t.string   "address"
    t.string   "ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "follows", force: true do |t|
    t.integer  "follower_user_id", limit: 8
    t.integer  "followed_user_id", limit: 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "likes", force: true do |t|
    t.integer  "sonic_id",   limit: 8
    t.integer  "user_id",    limit: 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "likes", ["sonic_id"], name: "index_likes_on_sonic_id", using: :btree

  create_table "notifications", force: true do |t|
    t.integer  "user_id",           limit: 8
    t.string   "notification_type"
    t.boolean  "is_read"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "to_sonic_id",       limit: 8
    t.integer  "by_user_id",        limit: 8
    t.integer  "comment_id"
  end

  create_table "reset_password_requests", force: true do |t|
    t.string "email"
    t.string "request_code"
  end

  create_table "sonics", id: false, force: true do |t|
    t.integer  "id",                           limit: 8,                 null: false
    t.integer  "user_id",                      limit: 8
    t.boolean  "is_private"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "tags"
    t.integer  "likes_count"
    t.integer  "comments_count"
    t.integer  "resonics_count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "sonic_data_file_name"
    t.string   "sonic_data_content_type"
    t.integer  "sonic_data_file_size"
    t.datetime "sonic_data_updated_at"
    t.boolean  "is_resonic",                             default: false
    t.integer  "original_sonic_id",            limit: 8
    t.string   "sonic_thumbnail_file_name"
    t.string   "sonic_thumbnail_content_type"
    t.integer  "sonic_thumbnail_file_size"
    t.datetime "sonic_thumbnail_updated_at"
  end

  add_index "sonics", ["is_resonic"], name: "index_sonics_on_is_resonic", using: :btree
  add_index "sonics", ["original_sonic_id"], name: "index_sonics_on_original_sonic_id", using: :btree

  create_table "users", id: false, force: true do |t|
    t.integer  "id",                         limit: 8,                 null: false
    t.string   "username"
    t.string   "email"
    t.string   "passhash"
    t.string   "fullname"
    t.string   "validation_code"
    t.boolean  "is_email_valid",                       default: false
    t.string   "website"
    t.string   "location"
    t.integer  "sonic_count"
    t.integer  "follower_count"
    t.integer  "following_count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "profile_image_file_name"
    t.string   "profile_image_content_type"
    t.integer  "profile_image_file_size"
    t.datetime "profile_image_updated_at"
    t.string   "gender"
    t.date     "date_of_birth"
    t.string   "search_index"
    t.boolean  "is_registered"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["is_registered"], name: "index_users_on_is_registered", using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
