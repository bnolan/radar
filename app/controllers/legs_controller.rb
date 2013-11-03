class LegsController < ApplicationController
  
  def show
    @trip = Trip.find params[:trip_id]

    if @trip.future? and !@trip.user.friends_with?(current_user)
      raise ActiveRecord::RecordNotFound
    end
    
    @leg = @trip.legs.find(params[:id])
  end

end
