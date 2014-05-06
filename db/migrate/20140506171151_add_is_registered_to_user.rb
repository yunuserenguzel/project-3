class AddIsRegisteredToUser < ActiveRecord::Migration
  def change
    add_column :users, :is_registered, :boolean
    add_index :users, :is_registered
  end
end
