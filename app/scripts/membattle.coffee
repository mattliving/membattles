define ["app", "imageEntity", "plant", "movingtext"], (App, ImageEntity, Plant, MovingText) ->

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
      initPlants(Math.floor(prob*4)+2, "medium")
      initPlants(Math.floor(prob*3)+1, "large")
      entities.push new ImageEntity(0, 0, "/images/floor.png", false)
      window.e = entities

    startAnimation: ->
      for eng, french of data
        entities.push new MovingText(french, ctx, 50, 400, 2000, -3000)
      i = 0
      text_entities = _.filter entities, (ent) -> ent instanceof MovingText
      setInterval(->
        if i < text_entities.length
          text_entities[i++].active = true
      , 1000)

      animate(canvas, ctx, Date.now())

    initPlants = (n, type) ->
      for i in [1..n]
        if type is "medium"
          plant = new Plant(0, 0, "/images/medium_plant.png", true)
        else
          plant = new Plant(0, 0, "/images/large_plant.png", true)
        plant.x = i
        plant.y = (if type is "medium_plant" then 280 else 256)
        entities.push plant

    animate = (canvas, ctx, lastTime) ->
      time = Date.now()
      dx = time - lastTime
      while dx > 0 # at the moment we do one tick per millisecond
        ctx.clearRect(0, 0, canvas.width, canvas.height)
        for entity in entities
          if entity? and entity.active and (not (entity instanceof ImageEntity) or entity.loaded)

            entity.draw(ctx)
            entity.update()

            # if entity.x > canvas.width - 100 or entity.y > canvas.height - 100
            #   entities.splice(entities.indexOf(entity), 1)
        dx--

      requestAnimFrame ->
        animate(canvas, ctx, time)
