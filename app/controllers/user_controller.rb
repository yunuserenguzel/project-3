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
      @validation_code = User.create_registration_request params
    end
  end

  prepare_params_for :validate,
                     :email => [:required, :not_empty],
                     :validation_code => [:required, :not_empty]
  def validate
    @email = params[:email]
    @validation_code = params[:validation_code]
    @user = User.validate_registration_request @email, @validation_code
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



end
