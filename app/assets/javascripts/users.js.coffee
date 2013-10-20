# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

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

$ ->
  window.users = new UserController