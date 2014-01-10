class Sonic < ActiveRecord::Base
  belongs_to :user, :class_name => 'User', :foreign_key => 'user_id'

  before_create :generate_sonic_id

  has_attached_file :sonic_data, {
      :url => "/system/sonic/u:idh:hash.:extension",
      :hash_secret => 'askdjfbhakjsfbkajsbglkajsbg',
      :bucket => ENV['S3_BUCKET_NAME'],
      :s3_credentials => {
          :access_key_id => ENV['S3_KEY'],
          :secret_access_key => ENV['S3_SECRET']
      }
  }

  def generate_sonic_id
    self.id = loop do
      id = rand(100000000..1000000000)
      break id unless User.exists?(id: id)
    end
  end


  def self.sql_with_where where
    <<SQL
      SELECT sonics.*
      FROM sonics
      INNER JOIN follows ON follows.followed_user_id=sonics.user_id
      INNER JOIN users ON users.id = sonics.user_id
      WHERE #{where}
      ORDER BY sonics.created_at DESC
      LIMIT 20
SQL
  end

  def self.get_sonic_feed_for_user user
    sql = Sonic.sql_with_where "follows.follower_user_id = ?"

    return Sonic.includes(:user).find_by_sql(sanitize_sql_array([sql,user.id]))
  end

  def self.get_sonic_feed_for_user_after_sonic user, sonic
    begin
      sonic = Sonic.find(sonic) if !sonic.is_a?Sonic
    rescue
      return []
    end
    sql = Sonic.sql_with_where "follows.follower_user_id = ? AND sonics.created_at > ?"
    return Sonic.find_by_sql(sanitize_sql_array([sql,user.id,sonic.created_at]))
  end

  def self.get_sonic_feed_for_user_before_sonic user, sonic
    begin
      sonic = Sonic.find(sonic) if !sonic.is_a?Sonic
    rescue
      return []
    end
    sql = Sonic.sql_with_where "follows.follower_user_id = ? AND sonics.created_at < ?"
    return Sonic.includes(:user).find_by_sql(sanitize_sql_array([sql,user.id,sonic.created_at]))
  end


  def like_sonic_for_user user
    user = user.is_a?(User) ? user.id : user
    self.dislike_sonic_for_user user
    Like.create(:sonic_id => self.id, :user_id=>user)
    return true
  end

  def dislike_sonic_for_user user
    user = user.is_a?(User) ? user.id : user
    Like.where(:sonic_id=>self.id, :user_id=>user).each do |like|
      like.destroy!
    end
    return true
  end


  def as_json options = {}
    json = super.as_json options
    json["sonic_data"] = self.sonic_data
    json['user'] = self.user
    return json
  end

  def self.likes_of_sonic sonic_id
    sql = <<SQL
      SELECT users.username,users.id,users.profile_image_file_name
      FROM likes INNER JOIN users ON users.id = likes.user_id
      WHERE likes.sonic_id=?
      LIMIT 100
SQL
    return User.find_by_sql(sanitize_sql_array [sql,sonic_id])
  end



end
