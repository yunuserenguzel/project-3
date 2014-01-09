require 'spec_helper'

describe UserController do
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
      @u1 = User.create
      token = Authentication.authenticate_user @u1
      @u2 = User.create
      @params = {:format=>'json',:token=>token,:user=>@u2.id}
    end
    it "returns success" do
      get :follow, @params
      response.should be_successful
      expect(User.get_followers_of_user_id(@u2.id).count).to eq 1
    end
  end

end
