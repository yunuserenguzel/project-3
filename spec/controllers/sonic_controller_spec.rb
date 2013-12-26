require 'spec_helper'

describe SonicController do
  render_views
  context "create_sonic" do
    before :each do
      sonic_data = fixture_file_upload('files/SNCKL001527e33e440a7c.snc', 'media/snc')
      u = User.new
      token = Authentication.authenticate_user u
      @params = {:format => 'json', :token => token, :sonic_data => sonic_data}
    end

    it "creates a sonic data at server" do
      post :create_sonic, @params
      response.should be_successful
    end
  end

  context "like sonic" do
    before :each do
      @sonic = Sonic.create
      @user = User.create
      token = Authentication.authenticate_user @user
      @params = {:format=>'json', :token=>token, :sonic=>@sonic.id}
      @sonic = Sonic.find(@sonic.id)
    end
    it "likes a sonic for authenticated user" do
      get :like_sonic, @params
      response.should be_successful
      response.body.should include(@sonic.to_json)
    end
    it "return error if sonic is not given" do
      @params.except! :sonic
      get :like_sonic, @params
      response.should be_redirect
      response.location.should include('error_code=')
    end
    it "returns error if given sonic id is not exists" do
      @params[:sonic] = 1
      get :like_sonic, @params
      response.should be_redirect
      response.location.should include('error_code=')
    end
  end

  context "dislike_sonic" do
    before :each do
      @sonic = Sonic.create
      @user = User.create
      token = Authentication.authenticate_user @user
      @sonic = Sonic.find(@sonic.id)
      @params = {:format => 'json', :token=>token, :sonic=>@sonic.id}
    end
    it "dislikes a sonic for authenticated user" do
      get :dislike_sonic, @params
      response.should be_successful
      response.body.should include(@sonic.to_json)
    end
    it "return error if sonic is not given" do
      @params.except! :sonic
      get :dislike_sonic, @params
      response.should be_redirect
      response.location.should include('error_code=')
    end
    it "returns error if given sonic id is not exists" do
      @params[:sonic] = 1
      get :dislike_sonic, @params
      response.should be_redirect
      response.location.should include('error_code=')
    end
  end

  context "get_sonics" do
    before :each do
      user = User.create
      user.follow_user user
      pivot_sonic = nil
      30.times do |number|
        sonic = Sonic.create(:owner_id=>user.id)
        sonic.created_at += number.hour
        sonic.save
        pivot_sonic = Sonic.find(sonic.id) if number == 13
      end
      token = Authentication.authenticate_user user
      @params = {:format=>'json',:token=>token,:after=>pivot_sonic.id, :before=>pivot_sonic.id}
    end

    it "brings the sonics after the given sonic id " do
      @params.except! :before
      get :get_sonics, @params
      response.should be_successful
    end
    it "brings the sonics before the given sonic id " do
      @params.except! :after
      get :get_sonics, @params
      response.should be_successful
    end
    it "brings the sonics" do
      @params.except! :before
      @params.except! :after
      get :get_sonics, @params
      response.should be_successful
    end
  end

  context "delete_sonic" do
    before :each do
      @user = User.create
      @sonic = Sonic.create(:owner_id => @user.id)
      puts @sonic.to_json
      @params = {:format => 'json', :token =>Authentication.authenticate_user(@user), :sonic=>@sonic.id}
    end
    it "returns successful" do
      get :delete_sonic, @params
      puts response.body
      response.should be_successful
      response.should_not be_redirect
    end
    it "returns error if sonic is not found" do
      @params[:sonic] = 1
      get :delete_sonic, @params
      #puts response.body
      response.should be_redirect
    end
    it "returns error if user is not owned the sonic" do
      @sonic.owner_id = User.create
      @sonic.save
      get :delete_sonic, @params
      response.should be_redirect
    end
  end

  context "likes" do
    before :each do
      @sonic = Sonic.create
      10.times do
        @sonic.like_sonic_for_user User.create.id
      end
      @params = {:format => 'json',:sonic=>@sonic.id, :token => Authentication.authenticate_user(User.create)}
    end

    it "returns success" do
      get :likes, @params
      puts response.body
      response.should be_successful
      response.should_not be_redirect
    end
  end
end
