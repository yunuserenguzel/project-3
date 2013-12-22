class CreateSonics < ActiveRecord::Migration
  def change
    create_table :sonics do |t|
      t.float :latitude
      t.float :longitude
      t.boolean :is_private
      t.integer :user
      t.integer :likes_count
      t.integer :comments_count
      t.integer :resonics_count
      t.timestamps
    end
    add_attachment :sonics, :sonic_data
  end
end
