class Api::NotificationController < ApplicationController
  before_action :require_authentication

  def get_last_notifications
    @notifications = Notification.get_last_notifications_for_user @authenticated_user
  end

  prepare_params_for :mark_as_read,
                     :notifications => [:required,:not_empty,:type=>Array]
  def mark_as_read
    notifications = params[:notifications]
    Notification.read notifications
  end


end
