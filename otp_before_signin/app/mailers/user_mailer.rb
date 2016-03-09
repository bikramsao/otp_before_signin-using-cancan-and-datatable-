class UserMailer < ApplicationMailer
	def send_signup_email(current_user)
    @user = current_user
    mail( :to => @user.email,
    :subject => 'Thanks for signing up and sign in by using following OTP' )
  end

  def send_otp_email(current_user)
    @user = current_user
    mail( :to => @user.email,
    :subject => 'sign in by using following OTP' )
  end
end
