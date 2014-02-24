require 'pn_manager'
class Notification < ActiveRecord::Base
  belongs_to :user, :class_name => 'User', :foreign_key => 'user_id'
  belongs_to :by_user, :class_name => 'User', :foreign_key => 'by_user_id'
  belongs_to :to_sonic, :class_name => 'Sonic', :foreign_key => 'to_sonic_id'
  belongs_to :comment, :class_name => 'Comment', :foreign_key => 'comment_id'

  before_create :on_before_create
  after_create :on_after_create

  def on_before_create
    self.is_read=false
    return true
  end

  def on_after_create
    if notification_type == 'like'
      message = "#{self.by_user.fullname} liked your sonic"
    elsif notification_type == 'comment'
      message = "#{self.by_user.fullname} commented on your sonic"
    elsif notification_type == 'resonic'
      message = "#{self.by_user.fullname} resoniced your sonic"
    elsif notification_type == 'follow'
      message = "#{self.by_user.fullname} is now following you"
    else
      return true
    end
    Authentication.where(:user_id => self.user_id).each do |auth|
      if auth && auth.push_token && auth.platform
        PNManager.send_new_notification_notification auth, message
      end
    end
    return true
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
    json['by_user'] = User.retrieve_user_for_user(self.by_user_id,options[:for_user].id).as_json options if self.by_user_id
    json['to_sonic'] = Sonic.retrieve_sonic_for_user(self.to_sonic_id,options[:for_user].id).as_json options if self.to_sonic_id
    json['comment'] = self.comment.as_json options if self.comment_id
    return json
  end

end

