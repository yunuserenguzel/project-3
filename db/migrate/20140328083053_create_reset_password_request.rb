class CreateResetPasswordRequest < ActiveRecord::Migration
  def change
    create_table :reset_password_requests do |t|
      t.string :email
      t.string :request_code
    end
  end
end
