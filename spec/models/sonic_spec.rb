require 'spec_helper'

describe Sonic do
  context "get_sonic_feed_for_user" do
    before :each do
      @user = User.create
      5.times do
        u = User.create
        s = Sonic.create
        s.user = u
        s.save
        @user.follow_user u
      end
    end

    it "gets the sonics of the followed users" do
      expect(Sonic.get_sonic_feed_for_user(@user).count).to eq(5)
    end
  end

  context "like_sonic" do
    before :each do
      @sonic = Sonic.create
      @user = User.create
    end
    it "likes a sonic" do
      @sonic.like_sonic_for_user @user
      expect(Like.first.sonic).to eq(@sonic)
      expect(Like.first.user).to eq(@user)
    end
    it "creates only one like object for a like" do
      @sonic.like_sonic_for_user @user
      @sonic.like_sonic_for_user @user
      @sonic.like_sonic_for_user @user
      @sonic.like_sonic_for_user @user
      expect(Like.all.count).to eq(1)
    end
  end

  context "unlike_sonic" do
    before :each do
      @sonic = Sonic.create
      @user = User.create
      @sonic.like_sonic_for_user @user
    end
    it "unlikes a sonic" do
      @sonic.unlike_sonic_for_user @user
      expect(Like.all.count).to eq(0)
    end
  end

end
