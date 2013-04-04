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

    initialize: (player1Things, player2Things) ->
      @$el.attr("width", $(".span12").css("width"))
      @ctx = @el.getContext("2d")
      @$playerHeader = $("#inputArea h2")
      @$player1      = $("#player1")
      @$player2      = $("#player2")
      @items = []
      @currentPlayer = 1
      @input = new InputHandler()
      @mediumPlants = 3
      @largePlants  = 2
      @floor = new Floor(0, @el.height/2, "/images/floor.png", 0, 1, true)
      @items.push @floor
      @initPlants(0, @el.height/2-4, @mediumPlants, "medium")
      @initPlants(0, @el.height/2-4, @largePlants, "large")
      @initCannons()
      @movingText = new TextView(player1Things, @floor, [400, 400], [2400, -3000])
      @items.push @movingText
      #@initMovingText()

    initPlants: (x, y, n, type) ->
      for i in [1..n]
        if type is "medium"
          plant   = new Plant(x, y, "/images/medium_plant.png", 1.1, 0.3, true)
          plant.x = i+@largePlants
          plant.y += 24
        else
          plant   = new Plant(x, y, "/images/large_plant.png", 1.1, 0.3, true)
          plant.x = i
        @items.push plant

    initCannons: ->
      @cannon1 = new Cannon(@mediumPlants+@largePlants+1, @el.height/2-4, "/images/cannon.png", 50, 1.2, false, true)
      @items.push @cannon1
      @cannon2 = new Cannon(@mediumPlants+@largePlants+5, @el.height/2-4, "/images/cannon.png", 50, 1.2, true, true)
      @items.push @cannon2

    setPlayer: ->
      if @currentPlayer is 1
        @$player2.removeClass("@currentPlayer")
        @$player1.addClass("@currentPlayer")
        @currentPlayer = 2
      else if @currentPlayer is 2
        @$player1.removeClass("@currentPlayer")
        @$player2.addClass("@currentPlayer")
        @currentPlayer = 1

      # @$playerHeader.text(@currentPlayer)

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
        for item in @items
          if item? and item.active
            item.draw(@ctx)
            item.update()
        @ms -= 10
      requestAnimFrame =>
        @animate(time)