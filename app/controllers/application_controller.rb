class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def authenticate_user!
    if !current_user
      flash[:notice] = "You must be logged in to access that page"
      redirect_to root_path
    end
  end
  
  def current_user
    @current_user ||= User.find_by_id session[:user_id]
  end
  helper_method :current_user
  
end
