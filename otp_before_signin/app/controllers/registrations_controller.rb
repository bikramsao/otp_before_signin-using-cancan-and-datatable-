class RegistrationsController < Devise::RegistrationsController
	skip_before_filter :require_no_authentication, only: [:new]
	require 'securerandom'

	def new
		super
	end
		
	def create
		@user = User.new(user_params)
		@user.otp = SecureRandom.urlsafe_base64(6)
		@user.activated = false
		if @user.save
			UserMailer.send_signup_email(@user).deliver_now
			redirect_to new_user_verification_path(@user)
		else 
			render 'new'
		end		
	end

	
	
	private 

	def user_params
		params.require(:user).permit( :name, :email , :password , :password_confirmation)
	end
end
