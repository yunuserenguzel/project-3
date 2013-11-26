class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.integer :sonic
      t.integer :user

      t.timestamps
    end
  end
end
