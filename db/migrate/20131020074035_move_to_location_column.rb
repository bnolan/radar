class MoveToLocationColumn < ActiveRecord::Migration
  def change
    add_column :legs, :location, :point, :geographic => true
    add_column :users, :location, :point, :geographic => true
    add_column :users, :city_path, :string
    
    Leg.all.each do |leg|
      leg.update_attributes! :location => Leg.factory.point(leg.longitude, leg.latitude)
    end
  end
end
