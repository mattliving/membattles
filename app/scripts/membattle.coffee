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
			x = i 
			y = (if type is "medium_plant" then 280 else 256)
			img.onload = () =>
				if type is "medium_plant"
					x = +x + large_plants.length + 0.1
				x = x*@width*0.35
				ctx.drawImage(@, x, y, @width*0.3, @height*0.3)
			a.push img

membattle = new Membattle()

