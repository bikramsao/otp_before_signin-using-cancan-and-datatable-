class UserMailer < ActionMailer::Base
  default :from => 'some_address@example.com'

  def send_signup_email(user)
    @user = user
    mail( :to => @user.email,
    :subject => 'Thanks for signing up and Reset the password' )
  end

end