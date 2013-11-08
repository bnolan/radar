module ApplicationHelper

  def foursquare_id
    "JE2OV0FLAUDIWBSYLYSSRUNEVJUKUWTPEAAAUVBIXLM203IU"
  end
  
  def foursquare_secret
    "GJOYQK2YNTOD03SR0ZOSD4EGIPNA0MOVW45KXPGS0AC5E5IL"
  end
  
  def our_date(d)
    d.strftime("%A, %b #{d.day.ordinalize}")
  end
  
  def our_date_and_year(d)
    d.strftime("%A, %b #{d.day.ordinalize}, %Y")
  end
  
  def trip_name(t)
    "Trip to " + t.legs.collect { |l| l.city.name }.uniq.to_sentence
  end
  
  def trip_duration(t)
    (if t.days == 0
      "<b>a single day</b> on <b>#{our_date_and_year(t.start)}</b>"
    else
      "<b>" + pluralize(t.days, 'day') + "</b>" +
      " from " +
      "<b>" + @trip.start.to_s + "</b> to <b>" + @trip.finish.to_s + "</b>"
    end).html_safe
  end
  
  def index_of_leg(leg)
    if leg.trip.legs.length == 1
      "Only"
    elsif leg.index_in_trip == 0
      "First"
    else
      (leg.index_in_trip + 1).ordinalize
    end
  end
end
