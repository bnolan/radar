class Venue < ActiveRecord::Base
  belongs_to :leg
  belongs_to :user
  validates_presence_of :name, :address

  delegate :latitude, :to => :location, :allow_nil => true
  delegate :longitude, :to => :location, :allow_nil => true
  
  self.rgeo_factory_generator = RGeo::Geos.factory_generator
  set_rgeo_factory_for_column(:location, RGeo::Geographic.spherical_factory(:srid => 4326))

  def self.factory
    f = Venue.rgeo_factory_for_column(:location)

    if f.is_a?(Proc)
      f.call({})
    else
      f
    end
  end
end
