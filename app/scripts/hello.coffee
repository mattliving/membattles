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

  explode: ->
    @ctx.beginPath()
    @ctx.arc(@x, @y, 40, 2*Math.PI, false)
    @ctx.fillStyle = "red"
    @ctx.fill()
    @ctx.fillStyle = "black"

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

        if text.x > canvas.width - 100 or text.y > canvas.height - 100
          text.explode()
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
