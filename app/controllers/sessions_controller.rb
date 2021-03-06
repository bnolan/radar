class SessionsController < ApplicationController

  skip_before_filter :verify_authenticity_token, :only => [:callback]

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
  
  def callback
    omniauth = request.env['omniauth.auth']
    authhash = {
      :uid => omniauth['uid'].to_i,
      :nickname => omniauth['info']['nickname'],
      :name => omniauth['info']['name'],
      :credentials => omniauth['credentials'],
      :image => omniauth['info']['image']
    }
    user = User.find_or_initialize_by(:uid => authhash[:uid])
    user.attributes = authhash
    user.save!
    session[:user_id] = user.id
    redirect_to root_path
  end

  def failure
    redirect_to root_path
  end


end
