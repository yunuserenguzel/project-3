class AuthenticationController < ApplicationController

  prepare_params_for :get_token,
                     :username => [:required, :not_empty],
                     :password => [:required, :not_empty]
  def get_token
    @username = params[:username]
    @password = params[:password]
    @platform = params[:platform]
    @user = User.check_user_login @username, @password
    if @user == nil
      show_error ErrorCodeUsernameOrPasswordIsWrong, "Please enter a valid username and password"
    end
    @token = Authentication.authenticate_user @user, @platform
  end


end
