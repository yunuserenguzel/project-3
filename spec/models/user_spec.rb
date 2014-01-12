require 'spec_helper'

describe User do
  context "generate_user_id" do
    it "generates a random unique id for user on create" do
      u = User.create
      expect(u.id>=User.min_user_id && u.id<=User.max_user_id).to eq(true)
    end
  end

  context "following" do
    before :each do
      @u1 = User.create
      @u2 = User.create
      @u1.follow_user @u2
    end
    context "follow_user" do
      it "can follow a user" do
        pending "revise for self follow"
        expect(@u1.followed_users[1]).to eq(@u2)
        expect(@u2.follower_users[1]).to eq(@u1)
      end
      it "follows only once for a same follower and same followed" do
        @u1.follow_user @u2
        expect(@u1.followeds.count).to eq 2
        expect(@u2.followers.count).to eq 2
      end
    end
    context "unfollow_user" do
      before :each do
        @u1.unfollow_user @u2
      end
      it "can unfollow a user" do
        pending 'revise for self follow'
        expect(@u1.followed_users[0]).to eq(nil)
        expect(@u2.follower_users[0]).to eq(nil)
      end
    end
    context "get_followers_of_user_id" do
      it "brings followers of user id" do
        expect(User.get_followers_of_user_id(@u2.id).count).to eq(1)
      end
    end
    context "get_followings_of_user_id" do
      it "brings followed users" do
        expect(User.get_followings_of_user_id(@u1.id).count).to eq(1)
      end
    end
  end

  context "registration" do
    before :each do
      @username = "username"
      @email = "email@email.com"
      @passhash = "passhash"
      @user = User.register({
          :username => @username,
          :email => @email,
          :passhash => @passhash })
      @validation_code = @user.validation_code
    end

    context "create_registration_request" do
      it "creates a regisration request" do
        expect(User.find(@user.id).username).to eq(@username)
      end
      it "returns the validation code" do
        expect(User.find(@user.id).validation_code).to eq(@validation_code)
      end
    end

  end


end