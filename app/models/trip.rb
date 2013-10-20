class Trip < ActiveRecord::Base
  has_many :legs
  belongs_to :user
  scope :upcoming, lambda { where('start >= ?', Date.today) }
  scope :past, lambda { where('start < ?', Date.today) }
  
  def visible_to(other)
    user == other
  end
  
  def days
    (finish - start).to_i
  end
  
  def future?
    Date.today <= start
  end

  def distance
    distance = user.location.distance(legs.first.location)
    
    previous_leg = legs.first
    
    legs.slice(1,100).each do |leg|
      distance += previous_leg.location.distance(leg.location)
    end
    
    distance += previous_leg.location.distance(user.location)

    (distance / 1000).to_i
  end
  
end
