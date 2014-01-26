class UserGenderAndDateOfBirth < ActiveRecord::Migration
  def change
    add_column :users, :gender, :string
    add_column :users, :date_of_birth, :date
    remove_column :users, :bio
  end
end
