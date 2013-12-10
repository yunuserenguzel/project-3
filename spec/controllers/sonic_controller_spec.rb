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
end
