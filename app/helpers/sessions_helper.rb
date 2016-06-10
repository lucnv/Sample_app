module SessionsHelper

  # Log in the given user
  def log_in(user)
  	session[:user_id] = user.id 
  end

  # Remembers a user in a persistent session.
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # return current logged-in user if any
  def current_user
    if session[:user_id]
  	  @current_user ||= User.find_by(id: session[:user_id])
	elsif cookies.signed[:user_id]
  	  user = User.find_by(id: cookies.signed[:user_id])
  	  if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
  	  end
    end
  end

  # check if the user logged-in
  def logged_in?
  	!current_user.nil?
  end

  def log_out
  	forget(current_user)
  	session.delete(:user_id)
  	@current_user = nil
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
end
