module ApplicationHelper
  
  def our_date(d)
    d.strftime("%A, %b #{d.day.ordinalize}")
  end
  
  def our_date_and_year(d)
    d.strftime("%A, %b #{d.day.ordinalize}, %Y")
  end
  
  def trip_name(t)
    "Trip to " + t.legs.collect { |l| l.city.name }.to_sentence
  end
end
