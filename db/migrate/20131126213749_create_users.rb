class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :passhash
      t.string :realname

      t.timestamps
    end
    add_attachment :users, :profile_image
  end
end
