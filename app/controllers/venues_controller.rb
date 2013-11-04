class VenuesController < ApplicationController
  before_filter :authenticate_user!

  def create
    leg = Leg.find venue_params[:leg_id]
    
    raise ActiveRecord::RecordNotFound unless leg.user == current_user
    
    venue = leg.venues.create!(
      :name => venue_params[:name],
      :address => venue_params[:address],
      :phone => venue_params[:phone],
      :website => venue_params[:website],
      :category => venue_params[:category],
      :icon => venue_params[:icon],
      :foreign_key => venue_params[:foreign_key],
      :notes => venue_params[:notes],
      :location => Venue.factory.point(venue_params[:longitude], venue_params[:latitude])
    )

    flash[:notice] = "The venue has been added to your trip"
    
    redirect_to [leg.trip, leg]
  end

  def destroy
    leg = Leg.find params[:leg_id]
    raise ActiveRecord::RecordNotFound unless leg.user == current_user
    Venue.find(params[:id]).destroy
    flash[:notice] = "The venue has been removed from your trip"
    redirect_to [leg.trip, leg]
  end
  
  protected
  
  def venue_params
    params.require(:venue).permit!
  end
  
end
