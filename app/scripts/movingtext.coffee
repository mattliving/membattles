define ["app", "item", "imageItem"], (App, Item, ImageItem) ->

  class MovingText extends Item

    constructor: (@floor, @text, @translation, @ctx, fx=0, fy=0, @active = false) ->
      @type = "text"
      @vx = 0
      @vy = 0
      @applyForce(fx, fy)
      @ctx.font = "15pt 'Comic Sans MS'"
      @collided = false
      @on "collided", (@success) ->
        @collided = true

    activate: (@active = true) -> @trigger("active")

    draw: (ctx) ->
      if @collided
        @explode(ctx)
        @expFrames ?= 0
        @expFrames++
        if @expFrames > 50
          @active = false
          @trigger("inactive")
      else
        ctx.fillText(@text, @x, @y)

    explode: (ctx) ->
      ctx.beginPath()
      ctx.arc(@x, @y, 40, 2*Math.PI, false)
      ctx.fillStyle = if @success then "green" else "red"
      ctx.fill()
      ctx.fillStyle = "black"

    applyForce: (fx, fy) ->
      @fx = fx*0.0005
      @fy = fy*0.0005

    i = 0
    update: ->
      if not @collided
        @vx += @fx
        @vy += @fy
        @x += @vx
        @y += @vy
        @applyForce(0, 9.8)

        xdiff = @x - @floor.x
        ydiff = @y - @floor.y
        if  0 < xdiff < @floor.img.width and 0 < ydiff < @floor.img.height
          @trigger("collided", false)
