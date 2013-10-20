require 'ostruct'

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
end