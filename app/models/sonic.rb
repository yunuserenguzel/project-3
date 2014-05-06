class Sonic < ActiveRecord::Base
  belongs_to :user, :class_name => 'User', :foreign_key => 'user_id'
  belongs_to :original_sonic, :class_name => 'Sonic', :foreign_key => 'original_sonic_id'

  before_create :generate_sonic_id
  after_save :update_sonic_count
  after_destroy :on_destroy

  has_attached_file :sonic_data, {
    :url => "/system/sonic/s:idh:hash.:extension",
    :hash_secret => 'askdjfbhakjsfbkajsbglkajsbg',
    :bucket => ENV['S3_BUCKET_NAME'],
    :s3_credentials => {
      :access_key_id => ENV['S3_KEY'],
      :secret_access_key => ENV['S3_SECRET']
    }
  }
  has_attached_file :sonic_thumbnail, {
    :url => "/system/sonic_thumbnail/st:idh:hash.:extension",
    :hash_secret => '1bb8d9303ns8d8d04n4n4gu7hs',
    :bucket => ENV['S3_BUCKET_NAME'],
    :s3_credentials => {
      :access_key_id => ENV['S3_KEY'],
      :secret_access_key => ENV['S3_SECRET']
    }
  }

  def generate_sonic_id
    self.id = loop do
      id = rand(1000000000000..9999999999999)
      break id unless User.exists?(:id => id)
    end
  end

  def self.retrieve_sonic_for_user sonic_id,user
    sonic_id = sonic_id.id if sonic_id.is_a?Sonic
    user = user.id if user.is_a?User
    sql = <<SQL
      SELECT DISTINCT sonics.*,
        CASE WHEN likes.user_id    IS NULL THEN 0 ELSE 1 END AS liked_by_me,
        CASE WHEN resonics.user_id IS NULL THEN 0 ELSE 1 END AS resoniced_by_me,
        CASE WHEN comments.user_id IS NULL THEN 0 ELSE 1 END AS commented_by_me
      FROM sonics
      LEFT JOIN likes ON (
        likes.user_id = ? AND
        likes.sonic_id = sonics.id
      )
      LEFT JOIN sonics AS resonics ON (
        resonics.user_id = ? AND
        resonics.original_sonic_id = sonics.id
      )
      LEFT JOIN comments ON (
        comments.user_id = ? AND
        comments.sonic_id = sonics.id
      )
      WHERE sonics.id = ?
      LIMIT 1
SQL
    Sonic.find_by_sql(sanitize_sql_array [sql, user,user,user,sonic_id]).first
  end

  def self.sql_with_params params
    where = ""
    where = sanitize_sql_array([' sonics.created_at > (SELECT created_at FROM sonics where sonics.id = ?)',params[:after]]) if params.has_key? :after
    where = sanitize_sql_array([' sonics.created_at < (SELECT created_at FROM sonics where sonics.id = ?) ',params[:before]]) if params.has_key? :before
    where += " AND " if where.length > 1
    if params.has_key? :of_user
      where += sanitize_sql_array [' sonics.user_id = ? ', params[:of_user]]
    elsif params.has_key? :me_liked
      where += sanitize_sql_array [' likes.user_id = ?', params[:user_id]]
    else
      where += sanitize_sql_array [' follows.follower_user_id = ?', params[:user_id]]
    end
    select_likes = <<SLCT
      SELECT sonics.*,
        CASE WHEN likes.user_id    IS NULL OR sonics.is_resonic=true THEN 0 ELSE 1 END AS liked_by_me,
        CASE WHEN resonics.user_id IS NULL OR sonics.is_resonic=true THEN 0 ELSE 1 END AS resoniced_by_me
SLCT
    select = <<SLCT
      #{select_likes},
        CASE WHEN comments.user_id IS NULL OR sonics.is_resonic=true THEN 0 ELSE 1 END AS commented_by_me
SLCT
    left_joins = <<LFT
      LEFT JOIN likes ON (
        likes.user_id = ? AND
        likes.sonic_id = sonics.id
      )
      LEFT JOIN sonics AS resonics ON (
        resonics.user_id = ? AND
        resonics.original_sonic_id = sonics.id
      )
      LEFT JOIN comments ON (
        comments.user_id = ? AND
        comments.sonic_id = sonics.id
      )
LFT
    left_joins = sanitize_sql_array [ left_joins, params[:user_id], params[:user_id], params[:user_id] ]
    rest = <<RST
      ORDER BY sonics.created_at DESC
      LIMIT 9
RST
    sql = <<SQL1
      #{select}
      FROM follows
      INNER JOIN sonics ON sonics.user_id = follows.followed_user_id
      #{left_joins}
      WHERE (sonics.is_resonic=true AND sonics.user_id<>follows.follower_user_id OR sonics.is_resonic=false) AND
      (#{where})
      #{rest}
SQL1
    if params.has_key? :of_user
      sql = <<SQL2
        #{select}
        FROM sonics
        #{left_joins}
        WHERE #{where}
        #{rest}
SQL2
    elsif params.has_key? :me_liked
      sql = <<SQL2
        #{select_likes}
        FROM likes
        INNER JOIN sonics ON sonics.id = likes.sonic_id
        LEFT JOIN sonics AS resonics ON (
          resonics.user_id = likes.user_id AND
          resonics.original_sonic_id = sonics.id
        )
        WHERE sonics.is_resonic = false AND #{where}
        #{rest}
SQL2
    end
    return sql
  end

  def self.get_sonic_feed_for_user user, params = {}
    user = user.id if user.is_a?User
    params[:user_id] = user
    sql = Sonic.sql_with_params params
    return Sonic.find_by_sql(sql)
  end


  def self.comment_sonic_for_user text,sonic,user
    sonic = sonic.id if sonic.is_a?Sonic
    user = user.id if user.is_a?User
    comment = Comment.create(:user_id => user, :sonic_id => sonic, :text => text)
    update_comments_count_for_sonic sonic
    return comment
  end

  def self.like_sonic_for_user sonic,user
    sonic = sonic.id if sonic.is_a?Sonic
    user = user.id if user.is_a?User
    if !Like.exists?(:sonic_id => sonic, :user_id => user)
      Like.create(:user_id => user, :sonic_id => sonic)
      update_likes_count_for_sonic sonic
    end
  end

  def self.unlike_sonic_for_user sonic,user
    sonic = sonic.id if sonic.is_a?Sonic
    user = user.id if user.is_a?User
    Like.destroy_all(:user_id => user, :sonic_id => sonic)
    update_likes_count_for_sonic sonic
  end

  def self.resonic_for_sonic_and_user sonic, user
    sonic = sonic.id if sonic.is_a?Sonic
    user = user.id if user.is_a?User
    if !Sonic.exists?(:user_id => user, :original_sonic_id => sonic, :is_resonic=>true)
      Sonic.create(:user_id => user,:original_sonic_id => sonic, :is_resonic=>true)
      update_resonics_count_for_sonic sonic
      Notification.createResonicNotification Sonic.find(sonic).user_id, sonic, user
    end
  end

  def self.delete_resonic_for_sonic_and_user sonic, user
    sonic = sonic.id if sonic.is_a?Sonic
    user = user.id if user.is_a?User
    Sonic.destroy_all(:user_id => user, :original_sonic_id => sonic, :is_resonic => true)
    update_resonics_count_for_sonic sonic
    Notification.deleteResonicNotification Sonic.find(sonic).user_id, sonic, user
  end

  def self.update_likes_count_for_sonic sonic
    sonic = sonic.id if sonic.is_a?Sonic
    sql = <<SQL
      UPDATE sonics
      SET likes_count = (
        SELECT COUNT(*) FROM likes WHERE sonic_id=sonics.id
      )
      WHERE sonics.id = ? AND sonics.is_resonic=false
SQL
    ActiveRecord::Base.connection.execute sanitize_sql_array([sql,sonic])
  end

  def self.update_resonics_count_for_sonic sonic
    sonic = sonic.id if sonic.is_a?Sonic
    sql = <<SQL
      UPDATE sonics
      SET resonics_count = (
        SELECT COUNT(*)
        FROM sonics AS resonics
        WHERE resonics.original_sonic_id=sonics.id AND resonics.is_resonic=true
      )
      WHERE sonics.id = ? AND sonics.is_resonic=false
SQL
    ActiveRecord::Base.connection.execute sanitize_sql_array([sql,sonic])
  end

  def self.update_comments_count_for_sonic sonic
    sonic = sonic.id if sonic.is_a?Sonic
    sql = <<SQL
      UPDATE sonics
      SET comments_count = (
        SELECT COUNT(*) FROM comments WHERE sonic_id=sonics.id
      )
      WHERE sonics.id = ? AND sonics.is_resonic=false
SQL
    ActiveRecord::Base.connection.execute sanitize_sql_array([sql,sonic])
  end

  def as_json options = {}
    self.user = User.retrieve_user_for_user self.user_id, options[:for_user]
    json = super.as_json options
    json["id"] = self.id.to_s
    json["sonic_data"] = self.sonic_data
    json['sonic_thumbnail'] = self.sonic_thumbnail
    json['user'] = self.user
    json['share_url'] = "http://www.sonicraph.com/sonic?s=#{self.id}"
    if(self.is_resonic)
      json['share_url'] = "http://www.sonicraph.com/sonic?s=#{self.original_sonic_id}"
      json['original_sonic'] = Sonic.retrieve_sonic_for_user self.original_sonic_id, options[:for_user]
    end
    return json
  end

  def on_destroy
    update_sonic_count
    Like.destroy_all(:sonic_id=>self.id)
    Comment.destroy_all(:sonic_id=>self.id)
    Sonic.where(:original_sonic_id => self.id).each do |sonic|
      sonic.destroy
    end
  end

  def update_sonic_count
    User.recalculate_and_save_sonic_count_for_user_id self.user_id
  end

  def self.get_users_resoniced_sonic_for_user sonic,user_id
    sonic = sonic.id if sonic.is_a?Sonic
    sql = <<SQL
      SELECT users.*,
        CASE WHEN follows.followed_user_id IS NULL THEN 0 ELSE 1 END AS is_being_followed
      FROM sonics
      INNER JOIN users ON users.id = sonics.user_id
      LEFT JOIN follows ON (follows.follower_user_id=? AND follows.followed_user_id=users.id)
      WHERE sonics.original_sonic_id=? AND sonics.is_resonic=true
      LIMIT 20
SQL
    return User.find_by_sql(sanitize_sql_array [sql,user_id,sonic])
  end

  def self.search_query_for_user query, user
    user = user.id if user.is_a?User
    sql = <<SQL
      SELECT set_limit(0.1);
      SELECT sonics.*, similarity(sonics.tags, ?) AS similarity,
        CASE WHEN likes.user_id    IS NULL OR sonics.is_resonic=true THEN 0 ELSE 1 END AS liked_by_me,
        CASE WHEN resonics.user_id IS NULL OR sonics.is_resonic=true THEN 0 ELSE 1 END AS resoniced_by_me,
        CASE WHEN comments.user_id IS NULL OR sonics.is_resonic=true THEN 0 ELSE 1 END AS commented_by_me
      FROM sonics
      LEFT JOIN likes ON (
        likes.user_id = ? AND
        likes.sonic_id = sonics.id
      )
      LEFT JOIN sonics AS resonics ON (
        resonics.user_id = ? AND
        resonics.original_sonic_id = sonics.id
      )
      LEFT JOIN comments ON (
        comments.user_id = ? AND
        comments.sonic_id = sonics.id
      )
      WHERE sonics.is_resonic = false AND sonics.tags IS NOT NULL AND sonics.tags % ?
      ORDER BY similarity DESC
      LIMIT 21;
SQL
    return Sonic.find_by_sql sanitize_sql_array([sql, query, user, user, user, query])
  end

end
