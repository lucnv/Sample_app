class SessionsController < ApplicationController

  before_action :already_logged_in, only: [:new, :create]

  def new
  end

  def create
  	user = User.find_by(email: params[:session][:email].downcase)
  	if user && user.authenticate(params[:session][:password])
      #login success
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_back_or user
  	else
  	  #create error message\
  	  flash.now[:danger] = 'Email or password is incorrect'
	  render 'new'
	  end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  def already_logged_in
    redirect_to(root_url) if logged_in?
  end
end
