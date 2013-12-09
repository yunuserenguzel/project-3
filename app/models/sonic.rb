class Sonic < ActiveRecord::Base
  belongs_to :user, :class_name => 'User', :foreign_key => 'user'

  before_create :generate_sonic_id

  has_attached_file :sonic_data, {
      :url => "/system/profile_images/u:idh:hash.:extension",
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

  def self.get_sonic_feed_for_user user
    return Sonic.joins(user: :followers).where(follows: {follower: user}).limit(20)
  end

  def like_sonic_for_user user
    self.unlike_sonic_for_user user
    like = Like.new
    like.user = user
    like.sonic = self
    like.save
    return true
  end

  def unlike_sonic_for_user user
    Like.where(:sonic=>self, :user=>user).each do |like|
      like.destroy!
    end
    return true
  end

  def as_json options = {}
    json = super.as_json options
    json["sonic_data"] = self.sonic_data
    return json
  end
end
