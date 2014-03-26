class EmailController < ApplicationController

  prepare_params_for :save_email,
                     :email => [:required, :not_empty, :type => String]
  def save_email
    @result = 'false'
    if Email.exists?(:address => params[:email])
      @result = 'exist'
    else
      Email.create(:address => params[:email], :ip => request.remote_ip)
      @result = 'true'
    end
  end

  def list
    @emails = Email.all
  end

end
