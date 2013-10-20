class User < ActiveRecord::Base
  require 'zip/zip'

  has_many :trips
  serialize :credentials, JSON
  delegate :latitude, :to => :location, :allow_nil => true
  delegate :longitude, :to => :location, :allow_nil => true
  
  self.rgeo_factory_generator = RGeo::Geos.factory_generator
  set_rgeo_factory_for_column(:location, RGeo::Geographic.spherical_factory(:srid => 4326))

  def to_param
    nickname
  end
  
  def friends
    User.where("uid in (0,#{friend_ids.join(',')}) and #{uid} = ANY(friend_ids)")
  end
  
  def city
    City.new_from_path(city_path, latitude, longitude)
  end

  def first_name
    name.split.first
  end
  
  def fetch_friend_ids!
    Twitter.configure do |config|
      config.consumer_key = $TWITTER_KEY
      config.consumer_secret = $TWITTER_SECRET
    end
    
    client = Twitter::Client.new(
      :oauth_token => credentials["token"],
      :oauth_token_secret => credentials["secret"]
    )
    
    self.friend_ids = get_friend_ids(client)

    # can't call save because postgres_ext and postgis gems are fighting, so...
    sql = "update users set friend_ids='{#{friend_ids.join(',')}}' where id=#{id};"
    ActiveRecord::Base.connection.execute(sql)
    
    
    # 
    # puts client.friends.to_a.each do |f|
    #   puts f.screen_name
    # end
    # users.collect(:screen_name).inspect
  end
  
  def self.factory
    User.rgeo_factory_for_column(:location)
  end

  def dopplr_import!(filename)
    json = JSON.parse(Zip::ZipFile.new(filename).read("full_data.json"))

    events = Zip::ZipFile.new(filename).read("trips.ics").split(/BEGIN:VEVENT/).map do |blob|
      begin
        notes = blob.match(/DESCRIPTION:(.+)GEO:/m)[1]

        if notes == "No notes so far.\r\n"
          notes = nil
        end
        
        {
          :start => Date.parse(blob.match(/DTSTART;VALUE=DATE:(\d+)/)[1]).to_date.to_s,
          :finish => Date.parse(blob.match(/DTEND;VALUE=DATE:(\d+)/)[1]).yesterday.to_date.to_s,
          :notes => notes
        }
      rescue
        nil
      end
    end.compact

    imported = 0
    skipped = 0
    
    json['trips'].each do |t|
      trip = self.trips.build(
        :start => t['start'],
        :finish => t['finish']
      )
      
      puts trip.start.to_date.to_s
      puts trip.finish.to_date.to_s
      
      if e = events.detect { |e| e[:start] == trip.start.to_date.to_s && e[:finish] == trip.finish.to_date.to_s }
        trip.notes = e[:notes]
      end
    
      trip.legs.build(
        :city_path => Leg.components_to_path([t['city']['country'], t['city']['name']]),
        :arrival => t['start'],
        :location => Leg.factory.point(t['city']['longitude'], t['city']['latitude'])
      )
      
      if self.trips.where(:start => trip.start, :finish => trip.finish).first
        skipped += 1
      else
        trip.save!
        imported += 1
      end
    end
    
    if skipped == 0
      "Success! Imported #{imported} trips."
    else
      "Success! Imported #{imported} trips, skipped #{skipped} potential duplicates."
    end
  end
  
  
  private
  
  def get_friend_ids(client)
    i = -1
    result = []
    while i != 0
      cursor = client.friend_ids(:cursor => i)
      result.concat cursor.collection
      i = cursor.next_cursor
    end
    result
  end
  
end
