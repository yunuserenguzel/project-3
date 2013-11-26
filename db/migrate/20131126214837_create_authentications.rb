class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.string :token
      t.integer :user
      t.string :platform
      t.string :push_token

      t.timestamps
    end
  end
end
