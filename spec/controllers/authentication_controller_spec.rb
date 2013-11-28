require 'spec_helper'

describe AuthenticationController do
render_views
  context "get_token" do
    before :each do
      @username = 'username'
      @email = 'email'
      @password = 'password'
      @validation_code = User.create_registration_request(:username => @username, :email=>@email, :password=>@password)
      User.validate_registration_request @email, @validation_code
      @params = {:format =>'json', :username => "username", :password => 'password'}
    end
    it "gets the token" do
      post :get_token, @params
      response.body.should include("token")
    end
  end
end
