class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :user_id
      t.string :notification_type
      t.string :data
      t.boolean :is_read
      t.timestamps
    end
  end
end
