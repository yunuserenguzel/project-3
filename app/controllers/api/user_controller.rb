class UserController < ApplicationController

  before_filter :require_authentication, :except => [:register,:validate,:login]

  prepare_params_for :register,
                     :email => [:required,:not_empty],
                     :password => [:required, :not_empty]
  def register
    @email = params[:email]
    if User.exists?(:email => @email)
      return show_error ErrorCodeEmailExists, "this email is already taken"
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

  def destroy_authentication
    Authentication.destroy_all(:token => Authentication.hash_token(params[:token]))
  end

  prepare_params_for :register_device_token,
                     :device_token => [:required, :not_empty],
                     :platform => [:required, :not_empty]
  def register_device_token
    Authentication.where(:token => Authentication.hash_token(params[:token])).each do |auth|
      auth.push_token = params[:device_token]
      auth.platform = params[:platform]
      auth.save
    end
  end


  prepare_params_for :edit,
                     :username => [:not_empty],
                     :password => [:not_empty],
                     :old_password => [:not_empty],
                     :email => [:not_empty],
                     :profile_image => [:not_empty],
                     :fullname => [:not_empty]
  def edit
    if params.has_key? :username
      @authenticated_user.username = params[:username]
      begin
        @authenticated_user.save
      rescue ActiveRecord::RecordNotUnique
        return show_error ErrorCodeUsernameExists, 'username is already exist'
      end
    end
    if params.has_key? :email
      @authenticated_user.email = params[:email]
      begin
        @authenticated_user.save
      rescue ActiveRecord::RecordNotUnique
        return show_error ErrorCodeEmailExists, 'email is already exist'
      end
    end
    if params.has_key? :password
      if !params.has_key? :old_password
        return show_error ErrorCodeMissingParameter, "old_password should be given for changing password"
      end
      if @authenticated_user.passhash == User.hash_password(params[:old_password])
        @authenticated_user.passhash=User.hash_password(params[:password])
      else
        return show_error ErrorCodePasswordMismatch, "old password is not your current password"
      end

    end
    if params.has_key? :website
      @authenticated_user.website = params[:website]
    end
    if params.has_key? :profile_image
      @authenticated_user.profile_image = params[:profile_image]
    end
    if params.has_key? :location
      @authenticated_user.location = params[:location]
    end
    if params.has_key? :fullname
      @authenticated_user.fullname = params[:fullname]
    end
    if params.has_key? :gender
      @authenticated_user.gender = params[:gender]
    end
    if params.has_key? :date_of_birth
      @authenticated_user.date_of_birth = params[:date_of_birth]
    end

    @authenticated_user.save
  end

  def check_is_token_valid
    #token = params[token]
    #returns the authenticated user
  end

  prepare_params_for :followers,
                     :user => [:required, :type => User]
  def followers
    @followers = User.followers_of_user_for_user params[:user], @authenticated_user.id
  end

  prepare_params_for :followings,
                     :user => [:required, :type => User]
  def followings
    @followings = User.followings_of_user_for_user params[:user], @authenticated_user.id
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

  prepare_params_for :search,
                     :query => [:required, :not_empty]
  def search
    @users = User.search_query_for_user params[:query], @authenticated_user
  end

end
