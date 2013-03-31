define ["app", "item", "imageItem", "floor", "plant", "cannon", "movingtext", "inputHandler"], 
(App, Item, ImageItem, Floor, Plant, Cannon, MovingText, InputHandler) ->

  class Membattle extends Backbone.Events
    
    $canvas = $("canvas")
    $canvas.attr("width", $(".span12").css("width"))
    canvas  = $canvas[0]
    ctx     = canvas.getContext("2d")
    items   = []
    currentPlayer = "Player One's Turn!"

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

    constructor: () ->
      @$playerHeader = $("#inputArea h2")
      @setPlayer()
      @input = new InputHandler()
      @ms = 0
      @mediumPlants = 3
      @largePlants  = 2
      @floor = new Floor(0, canvas.height/2, "/images/floor.png", 0, 1, true)
      items.push @floor
      @initPlants(0, canvas.height/2-4, @mediumPlants, "medium")
      @initPlants(0, canvas.height/2-4, @largePlants, "large")
      @cannon1 = new Cannon(@mediumPlants+@largePlants+1, canvas.height/2-4, "/images/cannon.png", 50, 1.2, false, true)
      items.push @cannon1
      @cannon2 = new Cannon(@mediumPlants+@largePlants+5, canvas.height/2-4, "/images/cannon.png", 50, 1.2, true, true)
      items.push @cannon2
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
        items.push plant

    initMovingText: (x, y) ->
      for eng, french of data1
        newText = new MovingText(@floor, french, eng, ctx, 2400, -3500)
        newText.listenTo @input, "change", (guess) ->
          if guess is @translation
            @trigger("collided", true)
        @cannon1.addText(newText)
        items.push newText

      for eng, french of data2
        newText = new MovingText(@floor, french, eng, ctx, -2400, -3500)
        newText.listenTo @input, "change", (guess) ->
          if guess is @translation
            @trigger("collided", true)
        @cannon2.addText(newText)
        items.push newText

      @cannon1.listenTo @cannon2, "exploded", ->
        console.log @, "cannon1"
        @trigger("nextText")

      @cannon2.listenTo @cannon1, "exploded", ->
        console.log @, "cannon2"
        @trigger("nextText")

      @input.listenTo @cannon1, "exploded", -> @$input.val("")
      @input.listenTo @cannon2, "exploded", -> @$input.val("")

    setPlayer: ->
      @$playerHeader.text(currentPlayer)

    startAnimation: ->
      # cheap and easy way to show text only at certain times.
      # i = 0
      # text_items = _.filter items, (e) -> e instanceof MovingText
      # text_items[i++].activate()
      # for j in [i..text_items.length-1]
      #   text_items[j].listenTo text_items[j-1], "inactive", -> @activate()
      @cannon1.trigger("nextText")
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



