class Sonic < ActiveRecord::Base
  belongs_to :user, :class_name => 'User', :foreign_key => 'user_id'

  before_create :generate_sonic_id
  after_save :update_sonic_count
  after_destroy :update_sonic_count

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
      id = rand(1000000000000..9999999999999)
      break id unless User.exists?(id: id)
    end
  end

  def self.retrieve_sonic_for_user sonic_id,user
    sonic_id = sonic_id.id if sonic_id.is_a?Sonic
    user = user.id if user.is_a?User
    sql = <<SQL
      SELECT sonics.*,
        CASE WHEN likes.user_id    IS NULL THEN 0 ELSE 1 END AS liked_by_me,
        CASE WHEN resonics.user_id IS NULL THEN 0 ELSE 1 END AS resoniced_by_me
      FROM sonics
      LEFT JOIN likes ON (
        likes.user_id = ? AND
        likes.sonic_id = sonics.id
      )
      LEFT JOIN resonics ON (
        resonics.user_id = ? AND
        resonics.sonic_id = sonics.id
      )
      WHERE sonics.id = ?
      LIMIT 1
SQL
    Sonic.find_by_sql(sanitize_sql_array [sql, user,user,sonic_id]).first
  end

  def self.sql_with_params params
    where = ""
    where = sanitize_sql_array([' AND sonics.created_at > ? ',params[:after]]) if params.has_key? :after
    where = sanitize_sql_array([' AND sonics.created_at < ? ',params[:before]]) if params.has_key? :before
    select = <<SLCT
      SELECT sonics.*,
        CASE WHEN likes.user_id    IS NULL THEN 0 ELSE 1 END AS liked_by_me,
        CASE WHEN resonics.user_id IS NULL THEN 0 ELSE 1 END AS resoniced_by_me,
SLCT
    rest = <<RST
      LEFT JOIN likes ON (
        likes.user_id = follows.follower_user_id AND
        likes.sonic_id = sonics.id
      )
      LEFT JOIN resonics ON (
        resonics.sonic_id = sonics.id AND
        resonics.user_id = follows.follower_user_id
      )
      WHERE follows.follower_user_id = ? #{where}
      ORDER BY sonics.created_at DESC
      LIMIT 20
RST
    sql = <<SQL
      (
        #{select}
          NULL AS resoniced_by_username,
          NULL AS resoniced_by_user_id
        FROM follows
        INNER JOIN sonics ON sonics.user_id = follows.followed_user_id
        #{rest}
      )
    UNION
      (
        #{select}
          resonicers.username AS resoniced_by_username,
          resonicers.id AS resoniced_by_user_id
        FROM follows
        INNER JOIN resonics AS RS ON RS.user_id = follows.followed_user_id
        INNER JOIN users AS resonicers ON resonicers.id=RS.user_id
        INNER JOIN sonics ON sonics.id = RS.sonic_id
        #{rest}
      )
SQL
    sanitize_sql_array [sql,params[:user_id],params[:user_id]]
  end

  def self.get_sonic_feed_for_user user
    user = user.id if user.is_a?User
    sql = Sonic.sql_with_params :user_id => user
    return Sonic.find_by_sql(sql)
  end

  def self.get_sonic_feed_for_user_after_sonic user, sonic
    begin
      sonic = Sonic.find(sonic) if !sonic.is_a?Sonic
    rescue
      return []
    end

    user = user.id if user.is_a?User
    sql = Sonic.sql_with_params :user_id => user, :after => sonic.created_at
    return Sonic.find_by_sql(sql)
  end

  def self.get_sonic_feed_for_user_before_sonic user, sonic
    begin
      sonic = Sonic.find(sonic) if !sonic.is_a?Sonic
    rescue
      return []
    end
    user = user.id if user.is_a?User
    sql = Sonic.sql_with_params :user_id => user, :before => sonic.created_at
    return Sonic.find_by_sql(sql)
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

  def self.resonic_for_sonic_and_user sonic, user
    sonic = sonic.id if sonic.is_a?Sonic
    user = user.id if user.is_a?User
    Resonic.create(
      :user_id => user,
      :sonic_id => sonic
    )
  end

  def as_json options = {}
    json = super.as_json options
    json["id"] = self.id.to_s
    json["sonic_data"] = self.sonic_data
    json['user'] = self.user
    return json
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

  def update_sonic_count
    User.recalculate_and_save_sonic_count_for_user_id self.user_id
  end

end
