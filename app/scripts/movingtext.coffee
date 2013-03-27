define ["app", "entity"], (App, Entity) ->

  class MovingText extends Entity

    constructor: (@text, @ctx, @x=0, @y=0, fx=0, fy=0, @active = false) ->
      @type = "text"
      @vx = 0
      @vy = 0
      @applyForce(fx, fy)
      @ctx.font = "12pt Helvetica"

    draw: (ctx) ->
      ctx.fillText(@text, @x, @y)

    # this doesn't work right now, needs to be a separate function
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
      @applyForce(0, 9.8)
