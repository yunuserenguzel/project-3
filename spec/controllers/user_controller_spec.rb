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
      puts response.body
    end

  end

  context "validate" do
    before :each do
      @validation_code = User.create_registration_request(:username=>'username',:email=>'email',:password=>'password')
      @params = {:format => 'json', :username => 'username', :validation_code => @validation_code, :email=>'email'}
    end

    it "can validate a registration" do
      post :validate, @params
      response.should be_successful
      response.body.should include('user')
    end
  end

end
