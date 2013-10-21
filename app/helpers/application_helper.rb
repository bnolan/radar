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
  
  def trip_duration(t)
    (if t.days == 0
      "<b>a daytrip</b> on <b>#{our_date_and_year(t.start)}</b>"
    else
      "<b>" + pluralize(t.days, 'day') + "</b>" +
      " from " +
      "<b>" + @trip.start.to_s + "</b> to <b>" + @trip.finish.to_s + "</b>"
    end).html_safe
  end
end
