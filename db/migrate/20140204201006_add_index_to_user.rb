class AddIndexToUser < ActiveRecord::Migration
  def change
    add_column :users, :search_index, :string
  end
end
