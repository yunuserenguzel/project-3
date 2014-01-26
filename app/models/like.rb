class Like < ActiveRecord::Base
  belongs_to :user, :class_name => 'User', :foreign_key => 'user_id'
  belongs_to :sonic, :class_name => 'Sonic', :foreign_key => 'sonic_id'

  after_create :on_created

  def on_created
    Notification.createLikeNotification self.sonic.user_id, self.sonic_id, self.user_id
  end

  def self.likes_of_sonic sonic_id
    sql = <<SQL
      SELECT users.*
      FROM likes INNER JOIN users ON users.id = likes.user_id
      WHERE likes.sonic_id=?
      LIMIT 20
SQL
    return User.find_by_sql(sanitize_sql_array [sql,sonic_id])
  end

end
