require 'spec_helper'

describe Api::AuthenticationController do
render_views
  context "get_token" do
    before :each do
      @username = 'username'
      @email = 'email'
      @password = 'password'
      @validation_code = User.register(:username => @username, :email=>@email, :password=>@password)
      User.validate_email @email, @validation_code
      @params = {:format =>'json', :username => "username", :password => 'password'}
    end
    it "gets the token" do
      post :get_token, @params
      response.body.should include("token")
    end
  end
end
