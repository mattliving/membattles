define ["marionette", "vent", "item", "imageItem", "floor", "plant", "cannon", "movingtext", "inputHandler"], 
(Marionette, vent, Item, ImageItem, Floor, Plant, Cannon, MovingText, InputHandler) ->

  class Membattle extends Marionette.View

    tagName: "canvas"

    attributes:
      height : "800px"

    data1 =
      sausage: "saucisson"
      frog: "grenouille"
      cat: "chat"
      fish: "poisson"
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
      @ms = 0
      @mediumPlants = 3
      @largePlants  = 2
      @floor = new Floor(0, @el.height/2, "/images/floor.png", 0, 1, true)
      @items.push @floor
      @initPlants(0, @el.height/2-4, @mediumPlants, "medium")
      @initPlants(0, @el.height/2-4, @largePlants, "large")
      @cannon1 = new Cannon(@mediumPlants+@largePlants+1, @el.height/2-4, "/images/cannon.png", 50, 1.2, false, true)
      @items.push @cannon1
      @cannon2 = new Cannon(@mediumPlants+@largePlants+5, @el.height/2-4, "/images/cannon.png", 50, 1.2, true, true)
      @items.push @cannon2
      @initMovingText()

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

    initMovingText: (x, y) ->
      for eng, french of data1
        newText = new MovingText(@ctx, @floor, french, eng, 2400, -3500)
        newText.listenTo @input, "change", (guess) ->
          if guess is @translation
            @trigger("collided", true)
        @cannon1.addText(newText)
        @items.push newText

      for eng, french of data2
        newText = new MovingText(@ctx, @floor, french, eng, -2400, -3500)
        newText.listenTo @input, "change", (guess) ->
          if guess is @translation
            @trigger("collided", true)
        @cannon2.addText(newText)
        @items.push newText

      @cannon1.listenTo @cannon2, "exploded", ->
        @trigger("nextText")

      @cannon2.listenTo @cannon1, "exploded", ->
        @trigger("nextText")

      @input.listenTo @cannon1, "exploded", -> @$input.val("")
      @input.listenTo @cannon2, "exploded", -> @$input.val("")

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
      # cheap and easy way to show text only at certain times.
      # i = 0
      # text_@items = _.filter @items, (e) -> e instanceof MovingText
      # text_@items[i++].activate()
      # for j in [i..text_@items.length-1]
      #   text_@items[j].listenTo text_@items[j-1], "inactive", -> @activate()
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



