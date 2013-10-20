# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

class TripController
  constructor: ->
    for row in $("table.legs tr.leg")
      @addAutocompleter($(row))
    
  addAutocompleter: (row) ->
    if not google?
      alert "Error loading autocompleter - please contact:\n\nbnolan@gmail.com"
      # developing at the pub
      return
      
    input = row.find("input[name*='[city]']")

    autocomplete = new google.maps.places.Autocomplete(input[0], { types : ['(regions)'] })

    google.maps.event.addListener autocomplete, 'place_changed', ->
      place = autocomplete.getPlace();

      path = place.address_components.map((c) ->
        c.long_name.replace('/','|').replace(/\s+/g,'+')
      ).reverse().join("/")
      
      row.find("input[name*='[city_path]']").val(path)
      row.find("input[name*='[latitude]']").val(place.geometry.location.lat())
      row.find("input[name*='[longitude]']").val(place.geometry.location.lng())
      
      console
      # 
      # $p =
      # path = place.address_components.map ->
    
    input.keydown (e) ->
      if e.keyCode == 13
        e.preventDefault()

  addLeg : ->
    row = $("table.legs tr.leg:last")
    index = parseInt(row.find('input').attr('name').match(/\d+/)[0]) + 1

    newRow = row.clone()
    newRow.find('input').val('').each ->
      this.name = $(this).attr('name').replace /\d+/, index
      
    newRow.insertAfter(row)

    @addAutocompleter(newRow)
    
  removeLeg: (sender) ->
    $(sender).parents('tr').remove()

$ ->
  window.trips = new TripController

    
#     if (!place.geometry) {
#       // Inform the user that the place was not found and return.
#       input.className = 'notfound';
#       return;
#     }
# 
#     // If the place has a geometry, then present it on a map.
#     if (place.geometry.viewport) {
#       map.fitBounds(place.geometry.viewport);
#     } else {
#       map.setCenter(place.geometry.location);
#       map.setZoom(17);  // Why 17? Because it looks good.
#     }
#     marker.setIcon(/** @type {google.maps.Icon} */({
#       url: place.icon,
#       size: new google.maps.Size(71, 71),
#       origin: new google.maps.Point(0, 0),
#       anchor: new google.maps.Point(17, 34),
#       scaledSize: new google.maps.Size(35, 35)
#     }));
#     marker.setPosition(place.geometry.location);
#     marker.setVisible(true);
# 
#     var address = '';
#     if (place.address_components) {
#       address = [
#         (place.address_components[0] && place.address_components[0].short_name || ''),
#         (place.address_components[1] && place.address_components[1].short_name || ''),
#         (place.address_components[2] && place.address_components[2].short_name || '')
#       ].join(' ');
#     }
# 
#     infowindow.setContent('<div><strong>' + place.name + '</strong><br>' + address);
#     infowindow.open(map, marker);
#   });
# 
#   // Sets a listener on a radio button to change the filter type on Places
#   // Autocomplete.
#   function setupClickListener(id, types) {
#     var radioButton = document.getElementById(id);
#     google.maps.event.addDomListener(radioButton, 'click', function() {
#       autocomplete.setTypes(types);
#     });
#   }
# 
#   setupClickListener('changetype-all', []);
#   setupClickListener('changetype-establishment', ['establishment']);
#   setupClickListener('changetype-geocode', ['geocode']);
# }
# 
# google.maps.event.addDomListener(window, 'load', initialize);
