class SessionsController < Devise::SessionsController
	def create
		user = User.find_by(email: params[:user][:email])
		if user.blocked == true
			flash[:danger] = 'Contact the admin to unblock!'
			redirect_to root_path
		elsif user.present? and user.valid_password?(params[:user][:password]) and ! user.activated
			redirect_to new_user_verification_path(user)
		else
			super
		end		
	end
end	
