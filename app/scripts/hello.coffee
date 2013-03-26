window.requestAnimFrame = do ((callback) ->
  window.requestAnimationFrame || window.webkitRequestAnimationFrame || window.mozRequestAnimationFrame || window.oRequestAnimationFrame || window.msRequestAnimationFrame || (callback) -> window.setTimeout(callback, 1000 / 60)
)
i = 0
animate = (text, canvas, ctx, lastTime, time) ->
  dx = Date.now() - lastTime

  ctx.clearRect(0, 0, canvas.width, canvas.height)

  text.vx += text.fx * 0.001
  text.vy += text.fy * 0.001

  text.x += text.vx
  text.y += text.vy

  while i++ < 200 then console.log time

  text.draw(ctx)

  text.fy = 9.8
  text.fx = 0

  requestAnimFrame (newTime) ->
    animate(text, canvas, ctx, dx, newTime)

canvas = $("canvas")[0]
ctx = canvas.getContext("2d")

ctx.font = "12pt Helvetica"

sausage =
  string: "saucisson"
  y: 400
  x: 50
  vx: 0
  vy: 0
  fx: 2000
  fy: -2100
  draw: (ctx) ->
    ctx.fillText(@string, @x, @y)

setTimeout(->
  animate(sausage, canvas, ctx, Date.now())
, 1000)
