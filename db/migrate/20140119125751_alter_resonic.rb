class AlterResonic < ActiveRecord::Migration
  def change
    drop_table :resonics
    add_column :sonics, :is_resonic, :boolean, :default => false
    add_column :sonics, :original_sonic_id, :integer, :limit => 8
    add_index :sonics, :original_sonic_id
    add_index :sonics, :is_resonic
  end
end
