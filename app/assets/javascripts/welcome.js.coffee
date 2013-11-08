# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

if window.google and window.google.maps and window.google.maps.OverlayView
  class ToolTip extends google.maps.OverlayView
    constructor: (map, point, place) ->
      @point = point
      @model = place
      @map = map

      if @model instanceof Place
        @div = $("
          <div class='popup-overlay'>
            <div class='inner'>
              <h4>#{@model.escape('name')}</h4>
            </div>
            <div class='chevron'>&nbsp;</div>
          </div>
        ")
      else
        @div = $("
          <div class='popup-overlay'>
            <div class='inner'>
              <h4>#{@model.getPlace().escape('name')}</h4>
              <!--address>#{@model.getPlace().escape('address')}</address-->
              <p class='comment'>
                #{@model.getTextSummary()}...
              </p>
              <p class='user'>
                <img src='/images/default_user_image.gif' class='avatar' />
                #{@model.getUser().escape('name') }
              </p>
            </div>
            <div class='chevron'>&nbsp;</div>
          </div>
        ")
    
      @div.click (e) =>
        window.location = @model.getPlace().get('full_path')

      @setMap(map)

    onAdd: ->
      @getPanes().floatPane.appendChild(@div[0])

    draw: ->
      projection = this.getProjection();

      pt = projection.fromLatLngToDivPixel(@point)

      @div.css({ 
        left : pt.x - 120
        top : pt.y - 45 - @div.height()
      })

    onRemove: ->
      @div.remove()


  @PlaceTooltip = PlaceTooltip
