require 'spec_helper'

describe Sonic do
  context "get_sonic_feed_for_user" do
    before :each do
      @user = User.create
      5.times do |i|
        u = User.create
        s = Sonic.create
        Sonic.resonic_for_sonic_and_user(s,@user) if i==2
        s.user_id = u.id
        s.save
        @user.follow_user u
      end
    end
    it "gets the sonics of the followed users" do
      expect(Sonic.get_sonic_feed_for_user(@user).count).to eq(6)
    end
  end

  context "get_sonic_feed_for_user_after_sonic" do
    before :each do
      @user = User.create
      @user.follow_user @user
      30.times do |number|
        sonic = Sonic.create(:user_id=>@user.id)
        sonic.created_at += number.hour
        sonic.save
        @pivot_sonic = Sonic.find(sonic.id) if number == 13
      end
    end
    it "get_sonic_feed" do
      expect(Sonic.get_sonic_feed_for_user(@user,:after=>@pivot_sonic.id).count).to eq(16)
    end
  end

  context "get_sonic_feed_for_user_before_sonic" do
    before :each do
      @user = User.create
      @user.follow_user @user
      30.times do |number|
        sonic = Sonic.create(:user_id=>@user.id)
        sonic.created_at += number.hour
        sonic.save
        @pivot_sonic = Sonic.find(sonic.id) if number == 13
      end
    end
    it "get_sonic_feed" do
      expect(Sonic.get_sonic_feed_for_user(@user,:before=>@pivot_sonic.id).count).to eq(13)
    end
  end

  context 'get_sonic_feed_for_user of_user' do
    before :each do
      @user = User.create
      @user1 = User.create
      @user2 = User.create
      @user1 = User.create
      @user2 = User.create
      20.times do |number|
        if number >= 7
          Sonic.create(:user_id => @user1.id)
        else
          Sonic.create(:user_id => @user2.id)
        end
      end
    end
    it "gets sonics of user" do
      expect(Sonic.get_sonic_feed_for_user(@user, :of_user=>@user1.id).count).to eq(13)
      expect(Sonic.get_sonic_feed_for_user(@user, :of_user=>@user2.id).count).to eq(7)
    end
  end

  context "like_sonic" do
    before :each do
      @sonic = Sonic.create
      @user = User.create
    end
    it "likes a sonic" do
      Sonic.like_sonic_for_user @sonic, @user
      expect(Like.first.sonic).to eq(@sonic)
      expect(Like.first.user).to eq(@user)
    end
    it "creates only one like object for a like" do
      Sonic.like_sonic_for_user @sonic, @user
      Sonic.like_sonic_for_user @sonic, @user
      Sonic.like_sonic_for_user @sonic, @user
      Sonic.like_sonic_for_user @sonic, @user
      Sonic.like_sonic_for_user @sonic, User.create
      @sonic = Sonic.find(@sonic.id)
      expect(@sonic.likes_count).to eq(2)
      Sonic.like_sonic_for_user @sonic, User.create
      @sonic = Sonic.find(@sonic.id)
      expect(@sonic.likes_count).to eq(3)
      Sonic.like_sonic_for_user @sonic, User.create
      expect(Like.all.count).to eq(4)
      @sonic = Sonic.find(@sonic.id)
      expect(@sonic.likes_count).to eq(4)
    end
  end

  context "unlike_sonic" do
    before :each do
      @sonic = Sonic.create
      @user = User.create
      Sonic.like_sonic_for_user @sonic, @user
    end
    it "unlikes a sonic" do
      Sonic.unlike_sonic_for_user @sonic, @user
      expect(Like.all.count).to eq(0)
    end
  end

  context "get likes" do
    before :each do
      @sonic = Sonic.create
      5.times do
        Sonic.like_sonic_for_user @sonic,User.create
      end
    end
    it "gets the users as array" do
      likes = Like.likes_of_sonic(@sonic.id)
      expect(likes.count).to eq(5)
    end
  end

  context "resonic" do
    before :each do
      @sonic = Sonic.create
      @u1 = User.create
      @u2 = User.create
      Sonic.resonic_for_sonic_and_user @sonic,@u1
      Sonic.resonic_for_sonic_and_user @sonic,@u2
      @sonic = Sonic.find(@sonic.id)
    end
    it "resonics for user " do
      expect(@sonic.resonics_count).to eq(2)
      expect(Resonic.where(:sonic_id => @sonic.id).count).to eq(2)
    end
    it "deletes resonics for user and sonic" do 
      Sonic.delete_resonic_for_sonic_and_user @sonic,@u1
      expect(Resonic.where(:sonic_id => @sonic.id).count).to eq(1)
      Sonic.delete_resonic_for_sonic_and_user @sonic,@u2
      expect(Resonic.where(:sonic_id => @sonic.id).count).to eq(0)
    end
  end

end
