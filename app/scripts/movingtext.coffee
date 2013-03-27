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
