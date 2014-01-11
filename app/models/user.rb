class User < ActiveRecord::Base

  before_create :generate_user_id

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

  def self.check_user_login username,password
    passhash = User.hash_password password
    user = User.where(:username => username, :passhash => passhash).first
    if user == nil
      User.where(:email => username, :passhash => passhash).first
    end
    return user
  end

  def follow_user user
    self.unfollow_user user
    f = Follow.new
    f.followed_user_id = user.is_a?(User) ? user.id : user
    f.follower_user_id = self.id
    f.save!
  end

  def unfollow_user user
    Follow.where(:followed_user_id => user, :follower_user_id => self).each do |f|
      f.destroy!
    end
  end

  def self.get_followings_of_user_id user
    user = user.id if user.is_a? User
    sql = <<SQL
          SELECT DISTINCT users.*,1 AS is_being_followed
          FROM users
          INNER JOIN follows ON follows.followed_user_id=users.id
          WHERE follows.follower_user_id=?
          GROUP BY users.id
SQL
    return User.find_by_sql(sanitize_sql_array([sql,user]))
  end

  def self.get_followers_of_user_id user
    user = user.id if user.is_a?(User)
    sql = <<SQL
          SELECT DISTINCT users.*,
            CASE WHEN follows2.followed_user_id IS NULL THEN 0 ELSE 1 END AS is_being_followed
          FROM users
          INNER JOIN follows ON follows.follower_user_id=users.id
          LEFT JOIN follows AS follows2 ON (follows2.follower_user_id=follows.followed_user_id AND follows2.followed_user_id=users.id)
          WHERE follows.followed_user_id=?
          GROUP BY users.id,follows2.followed_user_id
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
    user = User.where(:email => email, :validation_code => validation_code).first
    if user != nil
      user.validation_code = nil
      user.is_email_valid=true
      user.save
      return user
    else
      return false
    end
  end

  #def self.validate_registration_request email, validation_code
  #  rr = RegistrationRequest.where(:email => email, :validation_code => validation_code).first
  #  u = User.new
  #  u.email = rr.email
  #  u.username = rr.username
  #  u.passhash = rr.passhash
  #  u.save!
  #  u.follow_user u
  #  rr.destroy
  #  return u
  #end

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
    #json.except!("passhash")
    #json.except!("email")
    return json
  end
end