class UsersController < ApplicationController
  
  def update
    current_user.update_attributes!(
      :city_path => params[:user][:city_path],
      :location => User.factory.point(params[:user][:longitude], params[:user][:latitude])
    )
    flash[:notice] = "Set your home location"
    redirect_to root_path
  end

  def dopplr_import
    if request.post?
      begin
        flash[:notice] = current_user.dopplr_import!(
          params[:upload].path
        )
        redirect_to root_path
      rescue Exception => e
        flash[:alert] = "Sorry, there was an error importing your data, please email your export.zip to bnolan@gmail.com and we'll work out what went wrong."
      end
    end
  end
  
end
