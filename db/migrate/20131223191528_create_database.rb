class CreateDatabase < ActiveRecord::Migration
  def change

    create_table :users, :id => false do |t|
      t.integer :id, :limit => 8
      t.string :username
      t.string :email
      t.string :passhash
      t.string :fullname
      t.string :validation_code
      t.boolean :is_email_valid, :default => false
      t.string :website
      t.string :location
      t.string :bio
      t.integer :sonic_count, :default => 0
      t.integer :follower_count, :default => 0
      t.integer :following_count, :default => 0
      t.timestamps
    end
    add_attachment :users, :profile_image
    add_index :users, :username, :unique => true
    add_index :users, :email, :unique => true
    execute "ALTER TABLE users ADD PRIMARY KEY (id);"

    create_table :authentications do |t|
      t.string :token, :unique => true
      t.integer :user_id, :limit =>8
      t.string :platform
      t.string :push_token
      t.timestamps
    end
    add_index :authentications, :token

    create_table :follows do |t|
      t.integer :follower_user_id, :limit =>8
      t.integer :followed_user_id, :limit =>8
      t.timestamps
    end

    create_table :sonics, :id => false do |t|
      t.integer :id, :limit => 8
      t.integer :user_id, :limit =>8
      t.boolean :is_private
      t.float :latitude
      t.float :longitude
      t.string :tags
      t.integer :likes_count, :default => 0
      t.integer :comments_count, :default => 0
      t.integer :resonics_count, :default => 0
      t.timestamps
    end
    add_attachment :sonics, :sonic_data
    execute "ALTER TABLE sonics ADD PRIMARY KEY (id);"

    create_table :likes do |t|
      t.integer :sonic_id, :limit =>8
      t.integer :user_id, :limit =>8
      t.timestamps
    end
    add_index :likes, :sonic_id

    create_table :comments do |t|
      t.integer :sonic_id, :limit =>8
      t.integer :user_id, :limit =>8
      t.string :text
      t.timestamps
    end
    add_index :comments, :sonic_id
    add_index :comments, :user_id

    create_table :resonics do |t|
      t.integer :sonic_id, :limit =>8
      t.integer :user_id, :limit =>8
      t.timestamps
    end
    add_index :resonics, :user_id

    create_table :notifications do |t|
      t.integer :user_id, :limit =>8
      t.string :notification_type
      t.string :data
      t.boolean :is_read
      t.timestamps
    end

  end
end
