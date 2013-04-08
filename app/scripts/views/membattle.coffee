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

    ui:
      thisPlayer: "#thisPlayer"
      thatPlayer: "#thatPlayer"

    factory: {}
    items: []

    # this class is responsible for:
    # * connecting one player to the user input
    # * connecting the other player up to the server
    # * linking together the events of the two players
    initialize: (@thisPlayerManager, @thatPlayerManager) ->
      @$el.attr("width", $(".span12").css("width"))
      @ctx = @el.getContext("2d")
      @floor = new Floor(0, @el.height/2, 1, true)
      @thisPlayerManager.initialize(@floor)
      @thatPlayerManager.initialize(@floor)
      # @input = new InputHandler()
      # @currentPlayer = 1
      # @mediumPlants  = 3
      # @largePlants   = 2
      # # @initPlants(0, @el.height/2-4, @mediumPlants, "medium")
      # # @initPlants(0, @el.height/2-4, @largePlants, "large")
      # @initCannons()
      # @movingText = new TextView(player1Things, @floor, [400, 400], [2400, -3000])

    spawnItem: (type) ->
      item = new (@factory[typename])()
      @items.push item
      return item

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

    setPlayer: ->
      if @currentPlayer is 1
        @$player2.removeClass("currentPlayer")
        @$player1.addClass("currentPlayer")
        @currentPlayer = 2
      else if @currentPlayer is 2
        @$player1.removeClass("currentPlayer")
        @$player2.addClass("currentPlayer")
        @currentPlayer = 1

    initCannons: ->
      @cannon1 = new Cannon(@mediumPlants+@largePlants+1, @el.height/2-4, 50, 1.2, true)
      @cannon2 = new Cannon(@mediumPlants+@largePlants+5, @el.height/2-4, 50, 1.2, true)
      @cannon2.mirrored = true

    startAnimation: ->
      @ms = 0
      @thisPlayerManager.trigger("next")

      @thisPlayerManager.on 'endTurn', => @thatPlayerManager.trigger('next')
      @thatPlayerManager.on 'endTurn', => @thisPlayerManager.trigger('next')

      @update(Date.now())

    update: (lastTime) ->
      time = Date.now()
      dx = time - lastTime
      @ms += dx
      while @ms > 10
        @ctx.clearRect(0, 0, @el.width, @el.height)
        for item in Item.items
          if item? and item.active
            item.draw(@ctx)
            item.update()
        for item, i in @items
          unless item.active
            @items.splice(i, 1)
        @ms -= 10
      requestAnimFrame =>
        @update(time)
