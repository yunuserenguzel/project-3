class CreateSonics < ActiveRecord::Migration
  def change
    create_table :sonics do |t|
      t.float :latitude
      t.float :longitude
      t.boolean :is_private
      t.integer :user

      t.timestamps
    end
    add_attachment :sonics, :sonic_data
  end
end
