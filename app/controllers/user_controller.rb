class UserController < ApplicationController

  before_filter :require_authentication, :except => [:register,:validate,:login]

  prepare_params_for :register,
                     :email => [:required,:not_empty],
                     :password => [:required, :not_empty],
                     :username => [:required, :not_empty]
  def register
    @email = params[:email]
    @username = params[:username]
    if User.exists?(:email => @email)
      return show_error ErrorCodeEmailExists, "this email is already taken"
    elsif User.exists?(:username => @username)
      return show_error ErrorCodeUsernameExists, "this username is already taken"
    else
      @user = User.register(params)
      @token = Authentication.authenticate_user @user
    end
  end

  prepare_params_for :validate,
                     :email => [:required, :not_empty],
                     :validation_code => [:required, :not_empty]
  def validate
    @email = params[:email]
    @validation_code = params[:validation_code]
    @user = User.validate_email @email, @validation_code
  end

  prepare_params_for :login,
                     :username => [:required, :not_empty],
                     :password => [:required, :not_empty]
  def login
    username = params[:username]
    password = params[:password]
    @user = User.check_user_login username, password
    if @user.is_a?User
      @token = Authentication.authenticate_user @user
    else
      return show_error ErrorCodeUsernameOrPasswordIsWrong, "username or password is wrong login failed"
    end
  end

  prepare_params_for :check_is_token_valid,
                     :token => [:required, :not_empty]
  def check_is_token_valid
    token = params[token]
    #returns the authenticated user
  end

  prepare_params_for :followers,
                     :user => [:required, :type => User]
  def followers
    @followers = User.get_followers_of_user_id params[:user]
  end

  prepare_params_for :follow,
                     :user=> [:required, :type=>User];
  def follow
    @authenticated_user.follow_user params[:user]
  end
  prepare_params_for :unfollow,
                     :user=> [:required, :type=>User];
  def unfollow
    @authenticated_user.unfollow_user params[:user]
  end

end
