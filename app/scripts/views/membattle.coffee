define [
  "marionette",
  "vent",
  "item",
  "imageItem",
  "floor",
  "plant",
  "cannon",
  "views/textView",
  "inputHandler"
],
(Marionette, vent, Item, ImageItem, Floor, Plant, Cannon, TextView, InputHandler) ->
  class Membattle extends Marionette.View

    tagName: "canvas"

    attributes:
      height : "800px"

    data1 =
      hello: "konnichiwa"
      goodbye: "sayonara"
      "thank you": "arigatou gozaimasu"
      please: "kudasai"
      yes: "hai"
      no: "iie"

    data2 =
      tortoise: "tortue"
      mother: "mere"
      computer: "l'ordinateur"
      naughty: "mechant"

    initialize: () ->
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
      @movingText = new TextView(46239, @floor, [400, 400], [2400, -3000])
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

    ###initMovingText: ->
      for eng, french of data1
        newText = new MovingText(@ctx, @floor, french, eng, 2400, -3500)
        newText.listenTo @input, "change", (guess) ->
          if @active
            console.log "data1 incorrect"
            @trigger("collided", guess is @translation)
        @cannon1.addText(newText)
        @items.push newText

      for eng, french of data2
        newText = new MovingText(@ctx, @floor, french, eng, -2400, -3500)
        newText.listenTo @input, "change", (guess) ->
          if @active
            console.log "data2 incorrect"
            @trigger("collided", guess is @translation)
        @cannon2.addText(newText)
        @items.push newText

      @cannon1.listenTo @cannon2, "exploded", ->
        @trigger("nextText")

      @cannon2.listenTo @cannon1, "exploded", ->
        @trigger("nextText")

      @input.listenTo @cannon1, "exploded", -> @$input.val("")
      @input.listenTo @cannon2, "exploded", -> @$input.val("")###

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
