class Leg < ActiveRecord::Base
  belongs_to :trip
  belongs_to :user
  
  delegate :latitude, :to => :location
  delegate :longitude, :to => :location
  
  self.rgeo_factory_generator = RGeo::Geos.factory_generator
  set_rgeo_factory_for_column(:location, RGeo::Geographic.spherical_factory(:srid => 4326))

  def city
    City.new_from_path(city_path, latitude, longitude)
  end

  # def factory
  #   Leg.rgeo_factory_for_column(:location)
  # end

  def self.factory
    Leg.rgeo_factory_for_column(:location)
  end
  
  def self.components_to_path(components)
    components.map { |c| c.gsub('/','|').gsub(/\s+/,'+') }.join('/')
  end
end