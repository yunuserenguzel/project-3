class SonicraphMailer < ActionMailer::Base
  default :from => "Sonicraph / sonicraph.com <app23392587@heroku.com>"

  #def email_validation email, validation_code
  #  @email = email
  #  @url  = 'http://www.sonicraph.com/login'
  #  mail(:to => @user.email, :subject => 'Welcome to My Awesome Site')
  #end

  def reset_password email, validation_code
    @email = email
    @validation_code = validation_code
    mail(:to => @email, :subject => 'Reset password')
  end

end
