class VerificationsController < ApplicationController
	before_action :set_user, only: [:new, :create, :verify]
	require 'securerandom'

	def new
		@user=User.find_by(id: params[:user_id])
	end

	def create
		@user = User.find_by(id: params[:user_id])
    @user.otp = SecureRandom.urlsafe_base64(6)
	  if @user.save
			UserMailer.send_signup_email(@user).deliver_now
			redirect_to new_user_verification_path(@user)
		end	
	end

	def verify
    if @user.otp == verification_params[:otp]
	    @user.activated = true 
	    @user.save
	    redirect_to  new_user_session_path
	    flash[:success]="OTP matched"
  	else
  		flash[:danger] = "Enter the correct OTP"
    	redirect_to new_user_verification_path(@user)
  	end
	end

	private

	def set_user
		@user = User.find_by(id: params[:user_id])
	end

	def verification_params
		params.require(:user).permit(:otp)
	end

end
 