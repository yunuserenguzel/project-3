require 'spec_helper'

describe Api::UserController do
  render_views
  context "register" do

    before :each do
      @params = {:format => 'json', :username => 'username', :email => 'email', :password=>'password'}
    end

    it "can register a user" do
      post :register, @params
      response.should be_successful
      #puts response.body
    end

  end

  context "validate" do
    before :each do
      @validation_code = User.register(:username=>'username',:email=>'email',:password=>'password')
      @params = {:format => 'json', :username => 'username', :validation_code => @validation_code, :email=>'email'}
    end

    it "can validate a registration" do
      post :validate, @params
      response.should be_successful
      response.body.should include('user')
    end
  end


  context "check_is_valid_token" do
    before :each do
      @user = User.create(:username => "yeg")
      @token = Authentication.authenticate_user @user, 'ios'
      @params = {:format => "json", :token => @token}
      @user = User.find(@user.id)
    end

    it "returns the user " do
      get :check_is_token_valid, @params
      response.should be_successful
      response.body.should include(@user.to_json)
    end
  end

  context "followers" do
    before :each do
      @user = User.create(:username => 'yeg')
      @token = Authentication.authenticate_user @user
      u = User.create
      5.times do
        User.create.follow_user u
      end
      @params = {:format => 'json',:token => @token, :user=> u.id}
    end
    it "returns success" do
      get :followers, @params
      #puts response.body
      response.should be_successful
    end
  end

  context "follow" do
    before :each do
      @u1 = User.create(:username => 'u1', :fullname => 'fullname')
      token = Authentication.authenticate_user @u1
      @u2 = User.create(:username => 'u2', :fullname => 'fullname')
      @params = {:format=>'json',:token=>token,:user=>@u2.id}
    end
    it "returns success" do
      get :follow, @params
      response.should be_successful
      expect(User.followers_of_user_for_user(@u2.id).count).to eq 1
    end
  end

  context "followings" do
    before :each do
      @user = User.create(:username => 'yeg')
      @token = Authentication.authenticate_user @user
      5.times do |i|
        @user.follow_user User.create(:username => "u#{i}", :fullname => 'full')
      end
      @params = {:format => 'json',:token => @token, :user=> @user.id}
    end
    it "returns success" do
      get :followings, @params
      response.should be_successful
      expect(User.followings_of_user_for_user(@user.id).count).to eq 5
    end

  end

  context "edit" do
    before :each do
      @user = User.create(
        :passhash => User.hash_password('1234')
      )
      @params = {
        :format => 'json',
        :token => Authentication.authenticate_user(@user),
        :username => 'mmmm',
        :email => 'asd@asd',
        :password => '4321',
        :old_password => '1234',
        :location => 'Anywhere',
        :website => 'yunuserenguzel.com.tr',
        :gender => 'male',
        :date_of_birth => '1989-04-24',
        :fullname => 'Yunus ERen Guzel'
      }
    end
    it "returns successful" do
      post :edit, @params
      response.should be_successful
    end
  end

end
