class Leg < ActiveRecord::Base
  belongs_to :trip
  belongs_to :user
  
  delegate :latitude, :to => :location, :allow_nil => true
  delegate :longitude, :to => :location, :allow_nil => true
  
  self.rgeo_factory_generator = RGeo::Geos.factory_generator
  set_rgeo_factory_for_column(:location, RGeo::Geographic.spherical_factory(:srid => 4326))

  validates_presence_of :latitude, :longitude, :arrival, :city_path
  
  def city
    City.new_from_path(city_path, latitude, longitude)
  end

  # def factory
  #   Leg.rgeo_factory_for_column(:location)
  # end

  def self.factory
    f = Leg.rgeo_factory_for_column(:location)

    if f.is_a?(Proc)
      f.call({})
    else
      f
    end
  end
  
  def self.components_to_path(components)
    components.map { |c| c.gsub('/','|').gsub(/\s+/,'+') }.join('/')
  end
end