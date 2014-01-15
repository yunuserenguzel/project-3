class Resonic < ActiveRecord::Base
  belongs_to :user, :class_name => 'User', :foreign_key => 'user_id'
  belongs_to :sonic, :class_name => 'Sonic', :foreign_key => 'sonic_id'

  def self.get_users_resoniced_sonic sonic_id
    sql = <<SQL
      SELECT users.*
      FROM resonics INNER JOIN users ON users.id = resonics.user_id
      WHERE resonics.sonic_id=?
      LIMIT 20
SQL
    return User.find_by_sql(sanitize_sql_array [sql,sonic_id])
  end
end