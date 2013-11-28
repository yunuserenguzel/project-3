class User < ActiveRecord::Base

  before_create :generate_user_id

  has_many :followeds, :class_name => 'Follow', :foreign_key => 'follower'
  has_many :followed_users, :through => :followeds, :class_name => 'User', :source => 'followed'
  has_many :followers, :class_name => 'Follow', :foreign_key => 'followed'
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
    f.followed = user
    f.follower = self
    f.save!
  end

  def unfollow_user user
    Follow.where(:followed => user, :follower => self).each do |f|
      f.destroy!
    end
  end

  def self.create_registration_request params
    #TODO integrate with mail modules to sent mail
    rr = RegistrationRequest.new
    rr.username = params[:username]
    rr.email = params[:email]
    rr.passhash = User.hash_password params[:password]
    rr.validation_code = rand(User.min_user_id..User.max_user_id).to_s
    rr.save!
    return rr.validation_code
  end

  def self.validate_registration_request email, validation_code
    rr = RegistrationRequest.where(:email => email, :validation_code => validation_code).first
    u = User.new
    u.email = rr.email
    u.username = rr.username
    u.passhash = rr.passhash
    u.save!
    rr.destroy
    return u
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
    return 100000000
  end
  def self.max_user_id
    return 1000000000
  end

end