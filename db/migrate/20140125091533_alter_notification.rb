class AlterNotification < ActiveRecord::Migration
  def change
    remove_column :notifications, :data
    add_column :notifications, :to_sonic_id, :integer, :limit => 8
    add_column :notifications, :by_user_id, :integer, :limit => 8
    add_column :notifications, :comment_id, :integer
    add_column :users, :gender, :string
    add_column :users, :date_of_birth, :date
  end
end
