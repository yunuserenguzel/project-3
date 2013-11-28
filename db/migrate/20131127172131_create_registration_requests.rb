class CreateRegistrationRequests < ActiveRecord::Migration
  def change
    create_table :registration_requests do |t|
      t.string :username
      t.string :email
      t.string :passhash
      t.string :validation_code

      t.timestamps
    end
    add_index :registration_requests, :email, :unique => true
    add_index :registration_requests, :username, :unique => true
  end
end