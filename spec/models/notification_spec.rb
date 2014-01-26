require 'spec_helper'

describe Notification do
  before :each do
    @user = User.create
    @user = User.find(@user.id)
  end
  context "notify" do
    before :each do

    end

    it "creates a notification" do
      #notification = Notification.notify @user, "like", {:sonic_id=>1,:liker_id=>1}.to_json
      notification = Notification.createLikeNotification @user, 1, 1
      expect(notification.id).to eq(Notification.last.id)
    end

    it "defaultly sets is_read false" do
      notification = Notification.create
      expect(notification.is_read).to eq(false)
    end
  end

  context "read" do
    it "marks as read a notification" do
      n = Notification.create
      n.read
      n = Notification.find(n.id)
      expect(n.is_read).to eq(true)
    end
  end

  context "self.read" do
    it "marks as read given array of notification ids" do
      notification_ids = []
      6.times do
        notification_ids << Notification.create.id
      end
      Notification.read notification_ids
      notification_ids.each do |nid|
        notification = Notification.find(nid)
        expect(notification.is_read).to eq true
      end
    end

    it "does not raises error if given notification is not exists" do
      notification_ids = []
      5.times do
        notification_ids << 3
      end
      Notification.read notification_ids
    end
  end

  #context "get_unread_notifications_for_user" do
  #  it "brings the unread notifications of user" do
  #    5.times do
  #      n = Notification.createFollowNotification User.create, @user
  #      puts n
  #    end
  #    puts Notification.get_unread_notifications_for_user(@user)
  #    expect(Notification.get_unread_notifications_for_user(@user).count).to eq 5
  #    Notification.last.read
  #    expect(Notification.get_unread_notifications_for_user(@user).count).to eq 4
  #  end
  #end

  context "get_last_notifications_for_user" do
    it "brings last 20 notifications" do
      30.times do
        #Notification.notify @user, "type", {}.to_json
        Notification.createFollowNotification @user, User.create
      end
      expect(Notification.get_last_notifications_for_user(@user).count).to eq(20)
    end
  end
end
