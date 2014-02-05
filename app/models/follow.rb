class Follow < ActiveRecord::Base
  belongs_to :follower, :class_name => 'User', :foreign_key => 'follower_user_id'
  belongs_to :followed, :class_name => 'User', :foreign_key => 'followed_user_id'
  after_create :on_created
  after_destroy :on_destroy
  def on_created
    if self.followed_user_id != self.follower_user_id
      Notification.createFollowNotification self.followed, self.follower
    end
  end
  def on_destroy
    Notification.deleteFollowNotification self.followed, self.follower
  end
end
