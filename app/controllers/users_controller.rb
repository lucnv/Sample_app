class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def new
  	@user = User.new
  end

  def index
    @users = User.paginate(page: params[:page], per_page: 10)
  end

  def show
    begin
      @user = User.find(params[:id])  
    rescue Exception => e
      @user = nil
    end
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
  		#handle a successfull sign up
      @user.send_activation_email
      message = "Please check your email to activate your account!"
      message += "\n" + edit_account_activation_url(@user.activation_token,
                                                    email: @user.email)
      flash[:info] = message
      redirect_to root_url
  	else
  	  render 'new'
  	end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      #handle success
      flash[:success] = "Edit user successfully"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  # confirm admin user
  def admin_user
    redirect_to users_url unless current_user.admin?
  end

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
end
