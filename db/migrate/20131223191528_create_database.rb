class CreateDatabase < ActiveRecord::Migration
  def change


    create_table :registration_requests do |t|
      t.string :username
      t.string :email
      t.string :passhash
      t.string :validation_code
      t.timestamps
    end
    add_index :registration_requests, :email, :unique => true
    add_index :registration_requests, :username, :unique => true


    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :passhash
      t.string :fullname
      t.timestamps
    end
    add_attachment :users, :profile_image
    add_index :users, :username, :unique => true
    add_index :users, :email, :unique => true

    create_table :authentications do |t|
      t.string :token, :unique => true
      t.integer :user_id
      t.string :platform
      t.string :push_token
      t.timestamps
    end
    add_index :authentications, :token

    create_table :follows do |t|
      t.integer :follower_user_id
      t.integer :followed_user_id
      t.timestamps
    end

    create_table :sonics do |t|
      t.integer :user_id
      t.boolean :is_private
      t.float :latitude
      t.float :longitude
      t.integer :likes_count
      t.integer :comments_count
      t.integer :resonics_count
      t.timestamps
    end
    add_attachment :sonics, :sonic_data

    create_table :likes do |t|
      t.integer :sonic_id
      t.integer :user_id
      t.timestamps
    end
    add_index :likes, :sonic_id

    create_table :comments do |t|
      t.integer :sonic_id
      t.integer :user_id
      t.string :text
      t.timestamps
    end
    add_index :comments, :sonic_id
    add_index :comments, :user_id

    create_table :resonics do |t|
      t.integer :sonic_id
      t.integer :user_id
    end
    add_index :resonics, :user_id

    create_table :notifications do |t|
      t.integer :user_id
      t.string :notification_type
      t.string :data
      t.boolean :is_read
      t.timestamps
    end

  end
end
