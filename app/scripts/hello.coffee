<<<<<<< HEAD
window.requestAnimFrame = do ((callback) ->
  window.requestAnimationFrame || window.webkitRequestAnimationFrame || window.mozRequestAnimationFrame || window.oRequestAnimationFrame || window.msRequestAnimationFrame || (callback) -> window.setTimeout(callback, 1000 / 60)
)

data =
  sausage: "saucisson"
  frog: "grenoille"
  cat: "chat"
  fish: "poisson"
  tortoise: "tortue"
  mother: "mere"
  computer: "l'ordinateur"

window.elements = []

class MovingText

  constructor: (@text, @ctx, @x=0, @y=0, fx=0, fy=0) ->
    @vx = 0
    @vy = 0
    @applyForce(fx, fy)
    @ctx.font = "12pt Helvetica"

  draw: ->
    @ctx.fillText(@text, @x, @y)

  applyForce: (fx, fy) ->
    @fx = fx*0.0005
    @fy = fy*0.0005

  update: ->
    @vx += @fx
    @vy += @fy
    @x += @vx
    @y += @vy

  push: ->
    window.elements.push(@)


animate = (canvas, ctx, lastTime) ->
  time = Date.now()
  dx = time - lastTime
  while dx > 0 # at the moment we do one tick per millisecond
    ctx.clearRect(0, 0, canvas.width, canvas.height)
    
    for text in window.elements
      if text?
        text.update()

        text.draw()

        text.applyForce(0, 9.8)

        if text.x > canvas.width or text.y > canvas.height
          window.elements.splice(window.elements.indexOf(text), 1)
    dx--

  requestAnimFrame ->
    animate(canvas, ctx, time)

canvas = $("canvas")[0]
window.ctx = canvas.getContext("2d")

textEls = []
for eng, french of data
  textEls.push new MovingText(french, ctx, 50, 400, 2000, -3000)

i = 0
setInterval(->
  if i < textEls.length
    textEls[i++].push()
, 1000)

setTimeout(->
  animate(canvas, ctx, Date.now())
, 1000)

class Membattle

	prob = Math.random()

	canvas = $("canvas")[0]
	ctx = canvas.getContext("2d")
	medium_plants = []
	large_plants  = []

	constructor: (@canvas, @ctx) ->

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

membattle = new Membattle()

>>>>>>> 4cffef3da2d91f80ac0f66dff3b9c62bd02b0c61
