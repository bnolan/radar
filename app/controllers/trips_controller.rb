class TripsController < ApplicationController
  
  def create
    trip = current_user.trips.build trip_params
    build_legs(trip)
    trip.save!

    flash[:notice] = "Trip created"

    redirect_to trip
  end
  
  def update
    trip = current_user.trips.find params[:id]
    trip.attributes = trip_params
    build_legs(trip)
    trip.save!

    flash[:notice] = "The changes to your trip were saved"

    redirect_to trip
  end
  
  def show
    @trip = Trip.find params[:id]

    if not @trip.visible_to current_user
      raise ActiveRecord::RecordNotFound
    end
  end
    
  def edit
    @trip = current_user.trips.find params[:id]
  end

  def destroy
    current_user.trips.find(params[:id]).destroy
    flash[:notice] = "Your trip was deleted"
    redirect_to root_path
  end
  
  protected
  
  def trip_params
    params.require(:trip).permit(:finish, :notes)
  end  
  
  def build_legs(trip)
    trip.legs = []
    
    params[:trip][:leg].each do |index, leg_params|
      trip.legs.build(
        :city_path => leg_params[:city_path],
        :arrival => leg_params[:arrival],
        :location => Leg.factory.point(leg_params[:longitude], leg_params[:latitude])
      )
    end
    
    trip.start = trip.legs.first.arrival
  end
  
end
