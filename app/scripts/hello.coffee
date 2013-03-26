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

  constructor: (@string, @ctx, @x=0, @y=0, fx=0, fy=0) ->
    @vx = 0
    @vy = 0
    @applyForce(fx, fy)
    @ctx.font = "12pt Helvetica"

  draw: ->
    @ctx.fillText(@string, @x, @y)

  applyForce: (fx, fy) ->
    @fx = fx*0.01
    @fy = fy*0.01

  update: ->
    @vx += @fx
    @vy += @fy
    @x += @vx
    @y += @vy

  push: ->
    window.elements.push(@)

window.MovingText = MovingText

animate = (canvas, ctx, dx, time) ->
   # dx = Date.now() - lastTime

  ctx.clearRect(0, 0, canvas.width, canvas.height)
  
  for text in window.elements

    text.update()

    text.draw()

    text.applyForce(0, 9.8)

  requestAnimFrame ->
    animate(canvas, ctx, dx, time)

canvas = $("canvas")[0]
window.ctx = canvas.getContext("2d")

window.textEls = []
for eng, french of data
  textEls.push new MovingText(french, ctx, 50, 400, 600, -800)

i = 0
setInterval(->
  if i < textEls.length
    textEls[i++].push()
, 1000)

setTimeout(->
  animate(canvas, ctx, 0, 0)
, 1000)
