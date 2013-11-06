class Trip < ActiveRecord::Base
  require 'RMagick'
  
  has_many :legs
  belongs_to :user
  scope :upcoming, lambda { where('finish >= ?', Date.today) }
  scope :past, lambda { where('finish < ?', Date.today) }
  validates_presence_of :start, :finish
  before_save :recalculate_distance
  default_scope includes(:legs)
  scope :to_city, lambda { |country, city| where(:id => joins(:legs).where('legs.city_path ilike ?', "%/#{city}").select('distinct trip_id')) }
  after_save :delete_icon
  
  def day_trip?
    days == 0
  end
  
  def days
    (finish - start).to_i
  end
  
  # includes trips that haven't finished
  def future?
    Date.today <= finish
  end

  def recalculate_distance
    self.distance = if legs.empty?
      0
    else
      begin
        d = user.location.distance(legs.first.location)
    
        previous_leg = legs.first
    
        legs.slice(1,100).each do |leg|
          d += previous_leg.location.distance(leg.location)
        end
    
        d += previous_leg.location.distance(user.location)

        (d / 1000).to_i
      rescue
        0
      end
    end
  end

  # from http://www.carbonindependent.org/sources_aviation.htm
  def carbon_kg
    (distance * 0.033).to_i
  end
  
  def icon_path
    path = "/system/trip-icons/trip-icon-#{id}.png"
    full_path = Rails.root.to_s + "/public" + path

    if !File.exists? full_path
      generate_icon(full_path)
    end
    
    path
  end
  
  def delete_icon
    full_path = Rails.root.to_s + "/public" + "/system/trip-icons/trip-icon-#{id}.png"
    if File.exists? full_path
      File.delete(full_path)
    end
  end
  
  def generate_icon(path)
    canvas = Magick::Image.new(64, 64) # , Magick::HatchFill.new('white','lightcyan2'))
    gc = Magick::Draw.new

    width = 64.0 / legs.count
    
    legs.each_with_index do |leg, index|
      gc.fill(leg.city.color)
      gc.fill_opacity(1)
      gc.rectangle(index * width, 0, index * width + width, 64)
    end

    gc.draw(canvas)
    canvas.write(path)
  end
end
