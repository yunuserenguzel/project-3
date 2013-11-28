require 'spec_helper'

describe User do
  context "generate_user_id" do
    it "generates a random unique id for user on create" do
      u = User.new
      u.save
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
        expect(@u1.followed_users[0]).to eq(@u2)
        expect(@u2.follower_users[0]).to eq(@u1)
      end
      it "follows only once for a same follower and same followed" do
        @u1.follow_user @u2
        expect(@u1.followeds.count).to eq 1
        expect(@u2.followers.count).to eq 1
      end
    end
    context "unfollow_user" do
      before :each do
        @u1.unfollow_user @u2
      end
      it "can unfollow a user" do
        expect(@u1.followed_users[0]).to eq(nil)
        expect(@u2.follower_users[0]).to eq(nil)
      end
    end
  end

  context "registration" do
    before :each do
      @username = "username"
      @email = "email@email.com"
      @passhash = "passhash"
      @validation_code = User.create_registration_request({
          :username => @username,
          :email => @email,
          :passhash => @passhash })
    end

    context "create_registration_request" do
      it "creates a regisration request" do
        expect(RegistrationRequest.first.username).to eq(@username)
      end
      it "returns the validation code" do
        expect(RegistrationRequest.first.validation_code).to eq(@validation_code)
      end
    end

    context "validate_registration_request" do
      before :each do
        @user = User.validate_registration_request @email, @validation_code
      end
      it "removes the registration request" do
        expect(RegistrationRequest.first).to eq(nil)
      end
      it "creates a new user for the given request registration" do
        expect(User.first).to eq(@user)
        expect(@user.username).to eq(@username)
        expect(@user.email).to eq(@email)
        #expect(@user.passhash).to eq(@passhash)
      end
    end


  end
end