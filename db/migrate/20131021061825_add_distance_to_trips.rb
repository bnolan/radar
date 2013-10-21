class AddDistanceToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :distance, :integer
    
    Trip.all.each do |trip|
      if trip.valid?
        trip.recalculate_distance
        trip.save!
      end
    end
  end
end
