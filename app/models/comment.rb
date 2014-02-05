class Comment < ActiveRecord::Base
  belongs_to :user, :class_name => 'User', :foreign_key => 'user_id'
  belongs_to :sonic, :class_name => 'Sonic', :foreign_key => 'sonic_id'

  after_create :on_create
  after_destroy :on_destroy

  def on_create
    if self.sonic && self.sonic.user_id != self.user_id
      Notification.createCommentNotification self.sonic.user_id, self.sonic_id, self.id, self.user_id
    end
  end

  def on_destroy
    Sonic.update_comments_count_for_sonic self.sonic_id
    Notification.deleteCommentNotification self.sonic.user_id, self.sonic_id, self.id, self.user_id
  end


  def self.get_comments_for_sonic_id sonic_id
    sql = <<SQL
          SELECT comments.*
          FROM comments
          INNER JOIN users ON users.id = comments.user_id
          WHERE comments.sonic_id = ?
          ORDER BY comments.created_at ASC
          LIMIT 20
SQL
    return Comment.find_by_sql(sanitize_sql_array([sql,sonic_id]))
  end

  def as_json options = {}
    json = super.as_json options
    json['user'] = self.user
    return json
  end


end