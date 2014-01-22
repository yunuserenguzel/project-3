class User < ActiveRecord::Base

  before_create :generate_user_id
  after_create :follow_self
  has_many :followeds, :class_name => 'Follow', :foreign_key => 'follower_user_id'
  has_many :followed_users, :through => :followeds, :class_name => 'User', :source => 'followed'
  has_many :followers, :class_name => 'Follow', :foreign_key => 'followed_user_id'
  has_many :follower_users, :through => :followers, :class_name => 'User', :source => 'follower'

  has_attached_file :profile_image, {
      :url => "/system/profile_images/u:idh:hash.:extension",
      :hash_secret => 'askdjfbhakjsfbkajsbglkajsbg',
      :bucket => ENV['S3_BUCKET_NAME'],
      :s3_credentials => {
          :access_key_id => ENV['S3_KEY'],
          :secret_access_key => ENV['S3_SECRET']
      }
  }
  def follow_self
    self.follow_user self
  end

  def self.check_user_login username,password
    passhash = User.hash_password password
    user = User.where(:username => username, :passhash => passhash).first
    if user == nil
      User.where(:email => username, :passhash => passhash).first
    end
    return user
  end

  def follow_user user
    user = user.id if user.is_a?User
    self.unfollow_user user
    f = Follow.create(
      :followed_user_id => user,
      :follower_user_id => self.id
    )
    User.recalculate_and_save_follower_count_for_user_id user
    User.recalculate_and_save_following_count_for_user_id self.id
  end

  def self.recalculate_and_save_follower_count_for_user_id user
    user = user.id if user.is_a?User
    sql = <<SQL
      UPDATE users
      SET follower_count = (
        SELECT COUNT(*) FROM follows WHERE followed_user_id=users.id AND followed_user_id<>follower_user_id
      )
      WHERE users.id = ?
SQL
    ActiveRecord::Base.connection.execute sanitize_sql_array([sql,user])
  end

  def self.recalculate_and_save_following_count_for_user_id user
    user = user.id if user.is_a?User
    sql = <<SQL
      UPDATE users
      SET following_count = (
        SELECT COUNT(*) FROM follows WHERE follower_user_id=users.id AND followed_user_id<>follower_user_id
      )
      WHERE users.id = ?
SQL
    ActiveRecord::Base.connection.execute sanitize_sql_array([sql,user])
  end

  def self.recalculate_and_save_sonic_count_for_user_id user
    user = userr.id if user.is_a?User
    sql = <<SQL
    UPDATE users
      SET sonic_count = (
        SELECT COUNT(*) FROM sonics WHERE user_id=users.id
      )
      WHERE users.id = ?
SQL
    ActiveRecord::Base.connection.execute sanitize_sql_array([sql,user])
  end


  def unfollow_user user
    Follow.where(:followed_user_id => user, :follower_user_id => self).each do |f|
      f.destroy!
    end
  end

  def self.followings_of_user_for_user user, for_user = nil
    user = user.id if user.is_a?(User)
    for_user = for_user.id if for_user.is_a?User
    if for_user == nil
      select_case = ""
      left_join = ""
      group_by = ""
    else
      select_case = ",CASE WHEN follows2.followed_user_id IS NULL THEN 0 ELSE 1 END AS is_being_followed"
      left_join ="LEFT JOIN follows AS follows2 ON (follows2.follower_user_id=? AND follows2.followed_user_id=users.id)"
      left_join = sanitize_sql_array [left_join,for_user]
      group_by = ",follows2.followed_user_id"
    end
    sql = <<SQL
      SELECT DISTINCT users.*
        #{select_case}
      FROM users
      INNER JOIN follows ON follows.followed_user_id=users.id
      #{left_join}
      WHERE follows.follower_user_id=? AND follows.followed_user_id<>follows.follower_user_id
      GROUP BY users.id #{group_by}
SQL
    return User.find_by_sql(sanitize_sql_array([sql,user]))
  end

  def self.followers_of_user_for_user user, for_user = nil
    user = user.id if user.is_a?(User)
    for_user = for_user.id if for_user.is_a?User
    if for_user == nil
      select_case = ""
      left_join = ""
      group_by = ""
    else
      select_case = ",CASE WHEN follows2.followed_user_id IS NULL THEN 0 ELSE 1 END AS is_being_followed"
      left_join ="LEFT JOIN follows AS follows2 ON (follows2.follower_user_id=? AND follows2.followed_user_id=users.id)"
      left_join = sanitize_sql_array [left_join,for_user]
      group_by = ",follows2.followed_user_id"
    end
    sql = <<SQL
      SELECT DISTINCT users.*
        #{select_case}
      FROM users
      INNER JOIN follows ON follows.follower_user_id=users.id
      #{left_join}
      WHERE follows.followed_user_id=? AND follows.followed_user_id<>follows.follower_user_id
      GROUP BY users.id #{group_by}
SQL
    return User.find_by_sql(sanitize_sql_array([sql,user]))
  end

  def self.register params
    u = User.create
    u.email = params[:email]
    u.username = params[:username]
    u.passhash = User.hash_password params[:password]
    u.validation_code = rand(User.min_user_id..User.max_user_id).to_s
    u.save!
    u.follow_user u
    return u
  end

  def self.validate_email email, validation_code
    user = User.where(:email => email, :validation_code => validation_code.to_s).first
    if user != nil
      user.validation_code = nil
      user.is_email_valid=true
      user.save
      return user
    else
      return false
    end
  end

  def self.hash_password password
    return Digest::SHA1.hexdigest("sonic" + password.to_s + "craph")
  end

  def generate_user_id
    self.id = loop do
      id = rand(User.min_user_id..User.max_user_id)
      break id unless User.exists?(id: id)
    end
  end

  def self.min_user_id
    return 100000000000
  end
  def self.max_user_id
    return 999999999999
  end

  def as_json options = {}
    json = super.as_json
    json["id"] = self.id.to_s
    json["profile_image"] = self.profile_image
    json.except!("passhash")
    json.except!("email")
    return json
  end

  def self.search_query_for_user query, user
    query = query.strip
    if query.length < 4
      return []
    end
    user = user.id if user.is_a?User
    sql = <<SQL
      SELECT users.*,
        CASE WHEN follows.followed_user_id IS NULL THEN 0 ELSE 1 END AS is_being_followed
      FROM users
      LEFT JOIN follows ON (follows.follower_user_id=? AND follows.followed_user_id=users.id)
      WHERE users.username = ?
      LIMIT 20;
SQL
    return User.find_by_sql sanitize_sql_array([sql, user, query ])
  end
end