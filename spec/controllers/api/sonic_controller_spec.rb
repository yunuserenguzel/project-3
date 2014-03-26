require 'spec_helper'

describe Api::SonicController do
  render_views
  context "create_sonic" do
    before :each do
      sonic_data = fixture_file_upload('files/SNCKL001527e33e440a7c.snc', 'media/snc')
      u = User.create
      token = Authentication.authenticate_user u
      @params = {:format => 'json', :token => token,
                 :sonic_data => sonic_data,
                 :tags => 'asd',
                 :latitude => '1.123123123123',
                 :longitude => '2.123123123'}
    end

    it "creates a sonic data at server" do
      post :create_sonic, @params
      #puts response.body
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
      #response.body.should include(@sonic.to_json)
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
      #response.body.should include(@sonic.to_json)
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
        sonic = Sonic.create(:user_id=>user.id)
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
      @sonic = Sonic.create(:user_id => @user.id)
      #puts @sonic.to_json
      @params = {:format => 'json', :token =>Authentication.authenticate_user(@user), :sonic=>@sonic.id}
    end
    it "returns successful" do
      get :delete_sonic, @params
      #puts response.body
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
      @sonic.user_id = User.create
      @sonic.save
      get :delete_sonic, @params
      response.should be_redirect
    end
  end

  context "likes" do
    before :each do
      @sonic = Sonic.create
      10.times do
        Sonic.like_sonic_for_user @sonic, User.create
      end
      @params = {:format => 'json',:sonic=>@sonic.id, :token => Authentication.authenticate_user(User.create)}
    end

    it "returns success" do
      get :likes, @params
      #puts response.body
      response.should be_successful
      response.should_not be_redirect
    end
  end

  context "write comment" do
    before :each do
      @sonic = Sonic.create
      @params = {:format => 'json',
                 :sonic=>@sonic.id,
                 :token => Authentication.authenticate_user(User.create),
                 :text => 'asdasdasdasd'
      }
    end
    it "comments to a sonic" do
      post :write_comment, @params
      response.should be_successful
    end
  end

  context "comments" do
    before :each do
      @sonic = Sonic.create
      5.times do
        Comment.create(:user_id=>User.create.id,
                       :sonic_id => @sonic.id,
                       :text => 'asdasdasdasd'
        )
      end
      @params = {:format => 'json',
                 :sonic=>@sonic.id,
                 :token => Authentication.authenticate_user(User.create)
      }
    end
    it "comments to a sonic" do
      post :comments, @params
      #puts response.body
      response.should be_successful
    end
  end

  context "delete comment" do
    before :each do
      @user1 = User.create
      @user2 = User.create
      @user3 = User.create
      @sonic = Sonic.create(:user_id => @user1.id)
      @comment1 = Sonic.comment_sonic_for_user 'asd', @sonic.id, @user1.id
      @comment2 = Sonic.comment_sonic_for_user 'asd', @sonic.id, @user2.id
      @comment3 = Sonic.comment_sonic_for_user 'asd', @sonic.id, @user3.id
    end
    it "can delete own sonic's own comment" do
      get :delete_comment, {
        :format => 'json',
        :token => Authentication.authenticate_user(@user1),
        :comment => @comment1.id
      }
      response.should be_successful
    end
    it "can delete own comment" do
      get :delete_comment, {
        :format => 'json',
        :token => Authentication.authenticate_user(@user2),
        :comment => @comment2.id
      }
      response.should be_successful
    end
    it "can delete own sonic's other's comment" do
      get :delete_comment, {
        :format => 'json',
        :token => Authentication.authenticate_user(@user1),
        :comment => @comment3.id
      }
      response.should be_successful
    end

  end

  context "resonic" do
    before :each do
      sonic = Sonic.create
      user = User.create
      @params = {:format => 'json', :sonic => sonic.id, :token => Authentication.authenticate_user(user)}
    end

    it "returns http success" do
      get :resonic, @params
      response.should be_successful
    end
  end

  context 'delete_resonic' do
    before :each do
      sonic = Sonic.create
      user = User.create
      Sonic.resonic_for_sonic_and_user sonic,user
      @params = {:format => 'json', :sonic => sonic.id, :token => Authentication.authenticate_user(user)}
    end

    it "returns http success" do
      get :delete_resonic, @params
      response.should be_successful
    end
  end

  context 'resonics' do
    before :each do
      sonic = Sonic.create
      user = User.create
      10.times do
        Sonic.resonic_for_sonic_and_user sonic,User.create
      end
      @params = {:format => 'json', :sonic => sonic.id, :token => Authentication.authenticate_user(user)}
    end
    it "returns http success" do
      get :resonics, @params
      response.should be_successful
    end
  end
end
