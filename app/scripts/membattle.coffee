define ["jquery"], ($) ->

	class Membattle

		prob = Math.random()

		canvas = $("canvas")[0]
		ctx = canvas.getContext("2d")
		medium_plants = []
		large_plants  = []

		constructor: ->

			initPlants(large_plants, Math.floor(prob*4)+2, "large_plant")
			initPlants(medium_plants, Math.floor(prob*3)+1, "medium_plant")

		initPlants = (a, n, type) ->
			for i in [1..n]
				img = new Image()
				if type is "medium_plant"
					img.src = "/images/medium_plant.png"
				else
					img.src = "/images/large_plant.png" 
				img.dataset.type = type
				img.dataset.x = i
				img.dataset.y = (if type is "medium_plant" then 280 else 256)
				img.onload = onImageLoad
				a.push img

		onImageLoad = ->
			if @dataset.type is "medium_plant"
				@dataset.x = +@dataset.x + large_plants.length + 0.1
			@dataset.x = @dataset.x*@width*0.35
			ctx.drawImage(@, @dataset.x, @dataset.y, @width*0.3, @height*0.3)

