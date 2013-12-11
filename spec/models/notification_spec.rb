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
      notification = Notification.notify @user, "like", {:sonic_id=>1,:liker_id=>1}.to_json
      expect(notification.id).to eq(Notification.last.id)
    end

    it "defaultly sets is_read false" do
      notification = Notification.notify @user, "like", {:sonic_id=>1,:liker_id=>1}.to_json
      expect(notification.is_read).to eq(false)
    end
  end

  context "read" do
    it "marks as read a notification" do
      n = Notification.notify @user,"like",{}.to_json
      n.read
      n = Notification.find(n.id)
      expect(n.is_read).to eq(true)
    end
  end

  context "self.read" do
    it "marks as read given array of notification ids" do
      notification_ids = []
      5.times do
        notification_ids << Notification.create(:is_read => false).id
      end
      Notification.read notification_ids
      expect(Notification.where(:is_read=>false).count).to eq(0)
      expect(Notification.where(:is_read=>true).count).to eq(5)
    end

    it "does not raises error if given notification is not exists" do
      notification_ids = []
      5.times do
        notification_ids << 3
      end
      Notification.read notification_ids
    end
  end

  context "get_unread_notifications_for_user" do
    it "brings the unread notifications of user" do
      5.times do
        Notification.notify @user, "type", {}.to_json
      end
      expect(Notification.get_unread_notifications_for_user(@user).count).to eq 5
      Notification.last.read
      expect(Notification.get_unread_notifications_for_user(@user).count).to eq 4
    end
  end

  context "get_last_notifications_for_user" do
    it "brings last 20 notifications" do
      30.times do
        Notification.notify @user, "type", {}.to_json
      end
      expect(Notification.get_last_notifications_for_user(@user).count).to eq(20)
    end
  end
end
