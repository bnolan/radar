class Leg < ActiveRecord::Base
  belongs_to :trip
  # belongs_to :user
  has_many :venues
  
  delegate :latitude, :to => :location, :allow_nil => true
  delegate :longitude, :to => :location, :allow_nil => true
  
  self.rgeo_factory_generator = RGeo::Geos.factory_generator
  set_rgeo_factory_for_column(:location, RGeo::Geographic.spherical_factory(:srid => 4326))

  validates_presence_of :latitude, :longitude, :arrival, :city_path

  def user
    trip.user
  end
  
  def days
    (finish - start).to_i
  end
  
  def index_in_trip
    trip.legs.each_with_index { |leg, i| return i if leg == self}
    nil
  end
  
  def start
    arrival
  end
  
  def finish
    departure
  end
  
  def next_leg
    index_in_trip < trip.legs.count ? trip.legs[index_in_trip + 1] : nil
  end
  
  def departure
    next_leg ? next_leg.arrival : trip.finish
  end
  
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
  
  def self.unique_city_count
    Leg.select('distinct city_path').count
  end
  
  # def as_json(*args)
  #   {
  #     :city => city,
  #     :latitude => latitude,
  #     :longitude => longitude
  #   }
  # end
end