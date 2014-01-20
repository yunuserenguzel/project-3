class Comment < ActiveRecord::Base
  belongs_to :user, :class_name => 'User', :foreign_key => 'user_id'
  belongs_to :sonic, :class_name => 'Sonic', :foreign_key => 'sonic_id'
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