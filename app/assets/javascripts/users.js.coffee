# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

class Raumzeitgeist
  constructor: (username, trips) ->
    stylez = [
        {
          featureType: "all",
          elementType: "all",
          stylers: [
            { saturation: -80 }, { lightness: 30 }
          ]
        }
    ]

    mapOptions = {
      zoom : 2
      center : new google.maps.LatLng(12, 25)
      mapTypeId : google.maps.MapTypeId.ROADMAP
    }

    map = new google.maps.Map($('#zeitgeist-map')[0], mapOptions);

    mapType = new google.maps.StyledMapType(stylez, { name : "Grayscale" })    
    map.mapTypes.set('tehgrayz', mapType)
    map.setMapTypeId('tehgrayz')

    cities = {}
    
    maxCount = 0
    
    trips.forEach (trip) ->
      trip.legs.forEach (leg) ->
        cities[leg.city.name] ||= { 
          name : leg.city.name
          country : leg.city.country
          latitude : leg.latitude
          longitude : leg.longitude
          color : leg.city.color
          count : 0
        }
        
        maxCount = Math.max(maxCount, cities[leg.city.name].count++)
        
    for key, city of cities 
      do (city) ->
        scale = (5 / maxCount * city.count) + 5
      
        if scale.toString() == "Infinity"
          scale = 8
      
        new google.maps.Marker {
          position : new google.maps.LatLng(city.latitude, city.longitude)
          map : map
          icon: {
            path: google.maps.SymbolPath.CIRCLE
            fillOpacity: 0
            strokeColor: '555'
            strokeWeight: 2
            scale: scale + 2
          }
        }

        marker = new google.maps.Marker {
          position : new google.maps.LatLng(city.latitude, city.longitude)
          map : map
          title : "#{city.name}"
          icon: {
            path: google.maps.SymbolPath.CIRCLE
            fillColor : 'white'
            fillOpacity: 0.5
            strokeColor: city.color
            strokeWeight: 3
            scale: scale
          }
        }

        pathify = (path) ->
          path.replace('/','|').replace(/\s+/g,'+').toLowerCase()

        google.maps.event.addListener marker, 'click', ->
          window.location = ["", "users", username, 'cities', pathify(city.country), pathify(city.name)].join("/")
          # $(".show-legs tr#leg-#{leg.id}").addClass 'active'
        # 
        # google.maps.event.addListener marker, 'mouseout', ->
        #   $(".show-legs tr").removeClass 'active'
  
@Raumzeitgeist = Raumzeitgeist

class UserController
  constructor: ->
    if not google?
      alert "Error loading autocompleter - please contact:\n\nbnolan@gmail.com"
      # developing at the pub
      return

    form = $("form.edit_user")
    
    input = form.find("input[name*='[city]']")

    autocomplete = new google.maps.places.Autocomplete(input[0], { types : ['(regions)'] })

    google.maps.event.addListener autocomplete, 'place_changed', ->
      place = autocomplete.getPlace();

      path = place.address_components.map((c) ->
        c.long_name.replace('/','|').replace(/\s+/g,'+')
      ).reverse().join("/")
      
      form.find("input[name*='[city_path]']").val(path)
      form.find("input[name*='[latitude]']").val(place.geometry.location.lat())
      form.find("input[name*='[longitude]']").val(place.geometry.location.lng())

    input.keydown (e) ->
      if e.keyCode == 13
        e.preventDefault()

$ ->
  window.users = new UserController