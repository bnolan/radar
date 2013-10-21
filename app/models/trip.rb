class Trip < ActiveRecord::Base
  has_many :legs
  belongs_to :user
  scope :upcoming, lambda { where('finish >= ?', Date.today) }
  scope :past, lambda { where('finish < ?', Date.today) }
  validates_presence_of :start, :finish
  
  def days
    (finish - start).to_i
  end
  
  # includes trips that haven't finished
  def future?
    Date.today <= finish
  end

  def distance
    if legs.empty?
      0
    else
      distance = user.location.distance(legs.first.location)
    
      previous_leg = legs.first
    
      legs.slice(1,100).each do |leg|
        distance += previous_leg.location.distance(leg.location)
      end
    
      distance += previous_leg.location.distance(user.location)

      (distance / 1000).to_i
    end
  end

  # from http://www.carbonindependent.org/sources_aviation.htm
  def carbon_kg
    distance * 0.033
  end
end
