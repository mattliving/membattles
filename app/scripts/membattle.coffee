define ["app", "imageEntity", "plant"], (App, ImageEntity, Plant) ->

  class Membattle

    canvas   = $("canvas")[0]
    ctx      = canvas.getContext("2d")
    entities = []

    constructor: ->

      @mediumPlants = 4
      @largePlants  = 2
      entities.push new ImageEntity(0, canvas.height/2, "/images/floor.png", 0.8, false)
      @initPlants(0, canvas.height/2-20, @mediumPlants, "medium")
      @initPlants(0, canvas.height/2-20, @largePlants, "large")

    initPlants: (x, y, n, type) ->
      for i in [1..n]
        if type is "medium"
          plant   = new Plant(x, y, "/images/medium_plant.png", 0.3, false)
          plant.x = i+@largePlants
          plant.y += 24
        else
          plant   = new Plant(x, y, "/images/large_plant.png", 0.3, false)
          plant.x = i
        entities.push plant

    # onImageLoad = ->
    #   if @dataset.type is "medium_plant"
    #     @dataset.x = +@dataset.x + large_plants.length + 0.1
    #   @dataset.x = @dataset.x*@width*0.35
    #   ctx.drawImage(@, @dataset.x, @dataset.y, @width*0.3, @height*0.3)

    update: ->
      for entity in entities
        entity.draw(ctx)

