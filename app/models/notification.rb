class Notification < ActiveRecord::Base
  belongs_to :user, :class_name => 'User', :foreign_key => 'user_id'

  def self.notify user, notification_type, data
    user = user.id if user.is_a?User
    notification = Notification.create(:user_id=>user,
                                       :notification_type=>notification_type,
                                       :data=>data,
                                       :is_read=>false)
    return notification
  end

  def self.read notifications
    notifications.each do |notification|
      begin
        Notification.update(notification, :is_read => true)
      rescue

      end
    end if notifications.is_a?Array
  end

  def read
    self.is_read=true
    self.save
  end

  def self.get_unread_notifications_for_user user
    user = user.id if user.is_a?User
    notifications = Notification.where(:user_id => user,
                                       :is_read => false
    ).order(created_at: :desc)
    return notifications
  end

  def self.get_last_notifications_for_user user
    user = user.id if user.is_a?User
    return Notification.where(:user_id=>user).order(id: :desc).limit(20)
  end

end
