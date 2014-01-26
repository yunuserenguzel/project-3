require 'spec_helper'

describe NotificationController do
  render_views
  context "get_last_notifications" do
    before :each do
      user = User.create
      @n1 = Notification.createLikeNotification user,Sonic.create,User.create
      @n2 = Notification.createFollowNotification user, User.create
      @n3 = Notification.createResonicNotification user, Sonic.create, User.create
      @n4 = Notification.createCommentNotification user,Sonic.create,Comment.create, User.create
      @params = {
        :token => Authentication.authenticate_user(user),
        :format => 'json',
      }
    end

    it 'gets last notifications' do
      get :get_last_notifications, @params
      response.should be_successful
      #puts response.body
    end

    it "reads notifications" do
      @params['notifications'] = [@n1.id, @n2.id, @n3.id, @n4.id]
      post :mark_as_read, @params
      response.should be_successful
    end
  end


end
