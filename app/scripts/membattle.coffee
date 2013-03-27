define ["app", "imageEntity", "plant"], (App, ImageEntity, Plant) ->

	class Membattle

		prob = Math.random()

		canvas   = $("canvas")[0]
		ctx      = canvas.getContext("2d")
		entities = []

		constructor: ->

			initPlants(Math.floor(prob*4)+2, "medium")
			initPlants(Math.floor(prob*3)+1, "large")
			entities.push new ImageEntity(0, 0, "/images/floor.png", false)

		initPlants = (n, type) ->
			for i in [1..n]
				if type is "medium"
					plant = new Plant(0, 0, "/images/medium_plant.png", false)
				else
					plant = new Plant(0, 0, "/images/large_plant.png", false)
				plant.x = i
				plant.y = (if type is "medium_plant" then 280 else 256)
				entities.push plant

		# onImageLoad = ->
		# 	if @dataset.type is "medium_plant"
		# 		@dataset.x = +@dataset.x + large_plants.length + 0.1
		# 	@dataset.x = @dataset.x*@width*0.35
		# 	ctx.drawImage(@, @dataset.x, @dataset.y, @width*0.3, @height*0.3)

		update: ->
			for entity in entities
				entity.draw(ctx)

