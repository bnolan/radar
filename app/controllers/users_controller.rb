class UsersController < ApplicationController
  before_filter :authenticate_user!, :except => [:show]

  def index
    @friends = current_user.friends
    @users = User.where('(select count(trips.id) from trips where user_id=users.id)>1').order('created_at asc').all - @friends - [current_user]
  end
  
  def show
    @user = User.where('nickname ilike ?', params[:id]).first || raise(ActiveRecord::RecordNotFound)
  end

  def city
    @user = User.where('nickname ilike ?', params[:user_id]).first || raise(ActiveRecord::RecordNotFound)
    @city = City.find_by_country_and_name(params[:country], params[:name])
    @trips = @user.trips.to_city(params[:country], params[:name])
  end
  
  def update
    current_user.update_attributes!(
      :city_path => params[:user][:city_path],
      :email => params[:user][:email],
      :location => User.factory.point(params[:user][:longitude], params[:user][:latitude])
    )
    
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
