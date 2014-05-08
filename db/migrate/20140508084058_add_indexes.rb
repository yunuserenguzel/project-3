class AddIndexes < ActiveRecord::Migration
  def change
    add_index :follows, :follower_user_id
    add_index :follows, :followed_user_id
    add_index :follows, :created_at

    add_index :likes, :user_id
    add_index :likes, :created_at

    add_index :notifications, :user_id
    add_index :notifications, :is_read
    add_index :notifications, :created_at

    add_index :reset_password_requests, :email

    add_index :sonics, :user_id
    add_index :sonics, :created_at
  end
end
