class UsersController < ApplicationController
  load_and_authorize_resource


  def index
    respond_to do |format|
      format.html
      format.json { render json: UserDatatable.new(view_context) }
    end
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find_by_id(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Successfully created User." 
      redirect_to root_path
    else
      render :action => 'new'
      end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find_by(id: params[:id])
    params[:user].delete(:password) if params[:user][:password].blank?
    params[:user].delete(:password_confirmation) if params[:user][:password].blank? and params[:user][:password_confirmation].blank?
    if @user.update_attributes(user_params)
      flash[:success] = "Successfully updated User."
      redirect_to users_path
    else
      render :action => 'edit'
    end
  end

  def destroy
	  @user = User.find(params[:id])
	  @user.destroy
	   
	  respond_to do |format|
	    format.html { 
	    	flash[:success] = "Successfully deleted User."
      	redirect_to root_path
    	}
	    format.json { head :no_content }
	    format.js   { render :layout => false }
  	end
  end	

  def confirm
  	@user = User.find_by(id: params[:user_id])
  	@user.activated = true
	  @user.save
	  redirect_to users_path
	  flash[:success]="Account varified"
  end

  def block
  	@user = User.find_by(id: params[:user_id])
  	@user.blocked = true
  	@user.save
  	redirect_to users_path
  	flash[:success] = 'user successfully blocked'
  end
  	
  def unblock
  	@user = User.find_by(id: params[:user_id])
  	@user.blocked = false
  	@user.save
  	redirect_to users_path
  	flash[:success] = 'user successfully unblocked'
  end

  def change_user_role
    user = User.find_by(id: params[:id])
    user.update(update_role_params)
    render nothing: true
  end  

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :activated ,:role)
  end

  def update_role_params
    params.require(:user).permit(:role)
  end

end
