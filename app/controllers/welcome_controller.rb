class WelcomeController < ApplicationController
  
  def index
    if current_user and current_user.city.present?
      render :action => 'home'
    else
      render :action => 'settings'
    end
  end
    
end
