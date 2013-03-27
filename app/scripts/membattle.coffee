define ["app", "imageEntity", "plant", "cannon", "movingtext"], 
(App, ImageEntity, Plant, Cannon, MovingText) ->

  class Membattle

    prob = Math.random()
    canvas   = $("canvas")[0]
    ctx      = canvas.getContext("2d")
    entities = []

    data =
      sausage: "saucisson"
      frog: "grenoille"
      cat: "chat"
      fish: "poisson"
      tortoise: "tortue"
      mother: "mere"
      computer: "l'ordinateur"

    constructor: ->
      @mediumPlants = 3
      @largePlants  = 2
      entities.push new ImageEntity(0, canvas.height/2, "/images/floor.png", 0, 0.8, true)
      entities.push new Cannon(@mediumPlants+@largePlants, canvas.height/2, "/images/cannon.png", 50, 1.2, true)
      @initPlants(0, canvas.height/2-20, @mediumPlants, "medium")
      @initPlants(0, canvas.height/2-20, @largePlants, "large")
      for eng, french of data
        entities.push new MovingText(entities, french, ctx, 50, 400, 2000, -3000)


    initPlants: (x, y, n, type) ->
      for i in [1..n]
        if type is "medium"
          plant   = new Plant(x, y, "/images/medium_plant.png", 1.1, 0.3, true)
          plant.x = i+@largePlants-1
          plant.y += 24
        else
          plant   = new Plant(x, y, "/images/large_plant.png", 1.1, 0.3, true)
          plant.x = i-1
        entities.push plant

    startAnimation: ->
      # cheap and easy way to show text only at certain times.
      i = 0
      text_entities = _.filter entities, (e) -> e instanceof MovingText
      setInterval(->
        if i < text_entities.length
          text_entities[i++].active = true
      , 1000)

      @animate(canvas, ctx, Date.now())

    animate: (lastTime) ->
      time = Date.now()
      dx = time - lastTime
      while dx > 0 # at the moment we do one tick per millisecond
        ctx.clearRect(0, 0, canvas.width, canvas.height)
        for entity in entities
          if entity? and entity.active

            entity.draw(ctx)
            entity.update()

            # if entity.x > canvas.width - 100 or entity.y > canvas.height - 100
            #   entities.splice(entities.indexOf(entity), 1)
        dx--

      requestAnimFrame =>
        @animate(time)



