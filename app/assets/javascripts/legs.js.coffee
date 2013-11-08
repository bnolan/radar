# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

class CityMap
  constructor: (id, city, venues) ->
    @city = city
    @venues = venues

    bounds = new google.maps.LatLngBounds
    for v in venues when v.latitude
      bounds.extend new google.maps.LatLng(v.latitude, v.longitude)

    mapOptions = {
      zoom : 12
      center : new google.maps.LatLng(city.latitude, city.longitude)
      mapTypeId : google.maps.MapTypeId.TERRAIN
    }

    @map = new google.maps.Map($(id)[0], mapOptions);
    @map.fitBounds(bounds)
    
    setTimeout( =>
      console.log(@map.getZoom())
    
      if @map.getZoom() > 12
        @map.setZoom(12)
    , 250)
    
    venues.forEach (venue) =>
      latlng = new google.maps.LatLng(venue.latitude, venue.longitude)
      
      marker = new google.maps.Marker {
        position : latlng
        map : @map
        title : "#{venue.name}"
      }

      # google.maps.event.addListener marker, 'mouseover', =>
      #   @overlay = new Tooltip(@map, latlng, "#{venue.name}<br /><small>#{venue.address}</small>")
      # 
      # google.maps.event.addListener marker, 'mouseout', =>
      #   @overlay.setMap null
    
    
@CityMap = CityMap
  
class LegController
  constructor: (city) ->
    @city = city
    @addAutocompleter($('#new_venue'))
    
  addAutocompleter: (form) ->
    if not google?
      alert "Error loading autocompleter - please contact:\n\nbnolan@gmail.com"
      return
      
    input = form.find('#venue_name')
    
    autocomplete = new google.maps.places.Autocomplete(input[0], { 
      location : new google.maps.LatLng(@city.latitude, @city.longitude)
      radius : 15000
      # types : ['establishment']
    })

    google.maps.event.addListener autocomplete, 'place_changed', ->
      place = autocomplete.getPlace();

      console.log(place)

      form.find("input[name*='[latitude]']").val(place.geometry.location.lat())
      form.find("input[name*='[longitude]']").val(place.geometry.location.lng())
      form.find("input[name*='[foreign_key]']").val('google-' + place.id)
      form.find("input[name*='[website]']").val(place.website)
      form.find("input[name*='[phone]']").val(place.international_phone_number)
      form.find("input[name*='[category]']").val(place.types[0])
      form.find("input[name*='[icon]']").val(place.icon)
      
      address = place.address_components.map((c) ->
        c.long_name.replace('/','|').replace(/\s+/g,'+')
      ).join(", ")

      form.find("input[name*='[address]']").val(place.formatted_address)
      
      console
      # 
      # $p =
      # path = place.address_components.map ->
    
    input.keydown (e) ->
      if e.keyCode == 13
        e.preventDefault()

@LegController = LegController

# $("#venue_name").foursquareAutocomplete({
#   latitude: <%= @leg.city.latitude %>,
#   longitude: <%= @leg.city.longitude %>,
#   oauth_token: "your oauth token",
#   client_secret : "<%= foursquare_secret %>",
#   client_id : "<%= foursquare_id %>",
#   minLength: 3,
#   search: function (event, ui) {
#     $("#venue_name").val(ui.item.name);
#     $("#venue_foreign_key").val("foursquare-" + ui.item.id);
#     $("#venue_address").val([ui.item.address, ui.item.cityLine].join(", "));
#     $("#venue_category").val(ui.item.category);
#     $("#venue_latitude").val(ui.item.latitude);
#     $("#venue_longitude").val(ui.item.longitude);
#     return false;
#   },
#   onError : function (errorCode, errorType, errorDetail) {
#     var message = "Foursquare Error: Code=" + errorCode + ", errorType= " + errorType + ", errorDetail= " + errorDetail;
#     console.log(message);
#   }
# });
