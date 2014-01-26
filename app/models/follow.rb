class Follow < ActiveRecord::Base
  belongs_to :follower, :class_name => 'User', :foreign_key => 'follower_user_id'
  belongs_to :followed, :class_name => 'User', :foreign_key => 'followed_user_id'
  after_create :on_created

  def on_created
    Notification.createFollowNotification self.followed, self.follower
  end
end
