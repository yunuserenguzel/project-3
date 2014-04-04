class UserController < ApplicationController

  prepare_params_for :new_password,
                     :email => [:required, :not_empty],
                     :validation_code => [:required,:not_empty],
                     :message => []
  def new_password
    @validation_code = params[:validation_code]
    @email = params[:email]
    @message = params[:message]
  end

  prepare_params_for :set_new_password,
                     :email => [:required,:not_empty],
                     :validation_code => [:required,:not_empty],
                     :password => [:required, :not_empty],
                     :repassword => [:required, :not_empty]
  def set_new_password
    @email = params[:email]
    @password = params[:password]
    @repassword = params[:repassword]

    reset_request = ResetPasswordRequest.where(:email => @email, :request_code => params[:validation_code]).first
    if reset_request

      if @password == @repassword
        user = User.where(:email => params[:email]).first
        if user
          user.passhash= User.hash_password @password
        end
      else
        warn "passwords does not match"
        return
      end
    end
  end

  def warn msg
    redirect_to :controller => "user",
                :email => params[:email],
                :validation_code => params[:validation_code],
                :format => params[:format],
                :message => msg
  end

end
