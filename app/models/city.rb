require 'ostruct'
require 'digest'

class City < OpenStruct
  def self.new_from_path(path, latitude, longitude)
    if path.present?
      components = path.split('/')
    
      new(
        :name => components.last.gsub('+',' '),
        :latitude => latitude,
        :longitude => longitude
      )
    else
      new
    end
  end
  
  def blank?
    not present?
  end
  
  def present?
    name.present? and latitude.present? and longitude.present?
  end
  
  def color
    '#' + Digest::MD5.hexdigest(self.name).slice(0,6)
  end
  
  def serializable_hash(*args)
    as_json
  end

  def as_json(*args)
    { :name => name, :latitude => latitude, :longitude => longitude, :color => color }
  end
end
