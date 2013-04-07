define [
  "marionette",
  "vent",
  "items/item",
  "items/imageItem",
  "items/floor",
  "items/plant",
  "items/cannon",
  "views/textView",
  "inputHandler"
],
(Marionette, vent, Item, ImageItem, Floor, Plant, Cannon, TextView, InputHandler) ->
  class Membattle extends Marionette.View

    tagName: "canvas"

    attributes:
      height : "800px"

    initialize: (thisPlayer, thatPlayer) ->
      @$el.attr("width", $(".span12").css("width"))
      @ctx = @el.getContext("2d")
      @mediumPlants = 3
      @largePlants  = 2
      @floor = new Floor(0, @el.height/2, "/images/floor.png", 0, 1, true)
      # @initPlants(0, @el.height/2-4, @mediumPlants, "medium")
      # @initPlants(0, @el.height/2-4, @largePlants, "large")
      @initCannons()
      @movingText = new TextView(thisPlayer, @floor, [400, 400], [2400, -3000])

    # initPlants: (x, y, n, type) ->
    #   for i in [1..n]
    #     if type is "medium"
    #       plant   = new Plant(x, y, "/images/medium_plant.png", 1.1, 0.3, true)
    #       plant.x = i+@largePlants
    #       plant.y += 24
    #     else
    #       plant   = new Plant(x, y, "/images/large_plant.png", 1.1, 0.3, true)
    #       plant.x = i

    initCannons: ->
      @cannon1 = new Cannon(@mediumPlants+@largePlants+1, @el.height/2-4, "/images/cannon.png", 50, 1.2, true)
      @cannon2 = new Cannon(@mediumPlants+@largePlants+5, @el.height/2-4, "/images/cannon.png", 50, 1.2, true)
      @cannon2.mirrored = true

    startAnimation: ->
      @ms = 0
      @cannon1.trigger("nextText")
      @animate(Date.now())

    animate: (lastTime) ->
      time = Date.now()
      dx = time - lastTime
      @ms += dx
      while @ms > 10
        @ctx.clearRect(0, 0, @el.width, @el.height)
        for item in Item.items
          if item? and item.active
            item.draw(@ctx)
            item.update()
        @ms -= 10
      requestAnimFrame =>
        @animate(time)
