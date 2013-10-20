class WelcomeController < ApplicationController
  
  def index
    if current_user and current_user.city.present?
      render :action => 'home'
    elsif current_user
      render :action => 'settings'
    end
  end
    
end
