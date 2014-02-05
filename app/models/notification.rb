class Notification < ActiveRecord::Base
  belongs_to :user, :class_name => 'User', :foreign_key => 'user_id'
  belongs_to :by_user, :class_name => 'User', :foreign_key => 'by_user_id'
  belongs_to :to_sonic, :class_name => 'Sonic', :foreign_key => 'to_sonic_id'
  belongs_to :comment, :class_name => 'Comment', :foreign_key => 'comment_id'

  #
  #def self.notify user, notification_type, data
  #  user = user.id if user.is_a?User
  #  notification = Notification.create(:user_id=>user,
  #                                     :notification_type=>notification_type,
  #                                     :data=>data,
  #                                     :is_read=>false)
  #  return notification
  #end

  before_create :on_before_create
  after_create :on_after_create

  def on_before_create
    self.is_read=false
    return true
  end

  def on_after_create
  #  TODO: send push notification
  end

  def self.read notifications
    notifications = [notifications]  if !notifications.is_a?Array
    notifications.each do |notification|
      begin
        Notification.update(notification, :is_read => true)
      rescue
        if !Rails.env.test?
          puts "Notification with id:#{notification} is not found"
        end
      end
    end
  end

  def read
    self.is_read=true
    self.save
  end

  #def self.get_unread_notifications_for_user user
  #  user = user.id if user.is_a?User
  #  notifications = Notification.where(:user_id => user,
  #                                     :is_read => false
  #  ).order(created_at: :desc)
  #  return notifications
  #end

  def self.get_last_notifications_for_user user
    user = user.id if user.is_a?User
    return Notification.where(:user_id=>user).order(:id=> :desc).limit(20)
  end

  def self.createLikeNotification user, sonic, by_user
    user = user.id if user.is_a?User
    sonic = sonic.id if sonic.is_a?Sonic
    by_user = by_user.id if by_user.is_a?User
    return Notification.create(
      :notification_type => 'like',
      :user_id => user,
      :to_sonic_id => sonic,
      :by_user_id => by_user
    )
  end

  def self.deleteLikeNotification user, sonic, by_user
    user = user.id if user.is_a?User
    sonic = sonic.id if sonic.is_a?Sonic
    by_user = by_user.id if by_user.is_a?User
    Notification.delete_all(
      :notification_type => 'like',
      :user_id => user,
      :to_sonic_id => sonic,
      :by_user_id => by_user
    )
  end

  def self.createCommentNotification user, sonic, comment, by_user
    user = user.id if user.is_a?User
    sonic = sonic.id if sonic.is_a?Sonic
    comment = comment.id if comment.is_a?Comment
    by_user = by_user.id if by_user.is_a?User
    return Notification.create(
      :notification_type => 'comment',
      :user_id => user,
      :to_sonic_id => sonic,
      :comment_id => comment,
      :by_user_id => by_user
    )
  end

  def self.deleteCommentNotification user, sonic, comment, by_user
    user = user.id if user.is_a?User
    sonic = sonic.id if sonic.is_a?Sonic
    comment = comment.id if comment.is_a?Comment
    by_user = by_user.id if by_user.is_a?User
    Notification.delete_all(
      :notification_type => 'comment',
      :user_id => user,
      :to_sonic_id => sonic,
      :comment_id => comment,
      :by_user_id => by_user
    )
  end

  def self.createResonicNotification user, sonic, by_user
    user = user.id if user.is_a?User
    sonic = sonic.id if sonic.is_a?Sonic
    by_user = by_user.id if by_user.is_a?User
    return Notification.create(
      :notification_type => 'resonic',
      :user_id => user,
      :to_sonic_id => sonic,
      :by_user_id => by_user
    )
  end

  def self.deleteResonicNotification user, sonic, by_user
    user = user.id if user.is_a?User
    sonic = sonic.id if sonic.is_a?Sonic
    by_user = by_user.id if by_user.is_a?User
    Notification.delete_all(
      :notification_type => 'resonic',
      :user_id => user,
      :to_sonic_id => sonic,
      :by_user_id => by_user
    )
  end

  def self.createFollowNotification user, by_user
    user = user.id if user.is_a?User
    by_user = by_user.id if by_user.is_a?User
    return Notification.create(
      :notification_type => 'follow',
      :user_id => user,
      :by_user_id => by_user
    )
  end

  def self.deleteFollowNotification user, by_user
    user = user.id if user.is_a?User
    by_user = by_user.id if by_user.is_a?User
    Notification.delete_all(
      :notification_type => 'follow',
      :user_id => user,
      :by_user_id => by_user
    )
  end

  def as_json options = {}
    json = super.as_json options
    json['by_user'] = self.by_user.as_json options if self.by_user_id
    json['to_sonic'] = self.to_sonic.as_json options if self.to_sonic_id
    json['comment'] = self.comment.as_json options if self.comment_id
    return json
  end

end

