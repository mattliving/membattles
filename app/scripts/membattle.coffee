define ["app", "item", "imageItem", "floor", "plant", "cannon", "movingtext", "inputHandler"], 
(App, Item, ImageItem, Floor, Plant, Cannon, MovingText, InputHandler) ->

  class Membattle extends Backbone.Events
    
    $canvas = $("canvas")
    $canvas.attr("width", $(".span12").css("width"))
    canvas  = $canvas[0]
    ctx     = canvas.getContext("2d")
    items   = []

    data =
      sausage: "saucisson"
      frog: "grenouille"
      cat: "chat"
      fish: "poisson"
      tortoise: "tortue"
      mother: "mere"
      computer: "l'ordinateur"

    constructor: (@player1, @player2) ->
      # @player1.fetch((data) ->
      #   console.log data
      # )
      # @player2.fetch((data) ->
      #   console.log data
      # )
      @input = new InputHandler()
      @ms = 0
      @mediumPlants = 3
      @largePlants  = 2
      items.push new Floor(0, canvas.height/2, "/images/floor.png", 0, 1, true)
      cannon = new Cannon(@mediumPlants+@largePlants+1, canvas.height/2-4, "/images/cannon.png", 50, 1.2, true)
      items.push cannon
      @initPlants(0, canvas.height/2-4, @mediumPlants, "medium")
      @initPlants(0, canvas.height/2-4, @largePlants, "large")
      @initMovingText(cannon.x*cannon.offset+60, cannon.y-30)


    initPlants: (x, y, n, type) ->
      for i in [1..n]
        if type is "medium"
          plant   = new Plant(x, y, "/images/medium_plant.png", 1.1, 0.3, true)
          plant.x = i+@largePlants
          plant.y += 24
        else
          plant   = new Plant(x, y, "/images/large_plant.png", 1.1, 0.3, true)
          plant.x = i
        items.push plant

    initMovingText: (x, y) ->
      for eng, french of data
        newText = new MovingText(items, french, eng, ctx, x, y, 2400, -3500)
        @input.listenTo newText, "collided", (success) -> @.$input.val("")
        newText.listenTo @input, "change", (guess) ->
          if @active
            if @translation is guess
              @trigger("collided", true)
        items.push newText

    startAnimation: ->
      # cheap and easy way to show text only at certain times.
      i = 0
      text_items = _.filter items, (e) -> e instanceof MovingText
      text_items[i++].activate()
      for j in [i..text_items.length-1]
        text_items[j].listenTo text_items[j-1], "inactive", -> @activate()

      @animate(Date.now())

    animate: (lastTime) ->
      time = Date.now()
      dx = time - lastTime
      @ms += dx
      while @ms > 10
        ctx.clearRect(0, 0, canvas.width, canvas.height)
        for item in items
          if item? and item.active
            item.draw(ctx)
            item.update()
        @ms -= 10
      requestAnimFrame =>
        @animate(time)



