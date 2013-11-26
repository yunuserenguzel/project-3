class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :type
      t.integer :actor_user
      t.integer :sonic
      t.integer :affected_user
      t.boolean :is_read

      t.timestamps
    end
  end
end
