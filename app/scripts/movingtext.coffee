define ["app", "entity", "imageEntity"], (App, Entity, ImageEntity) ->

  class MovingText extends Entity

    constructor: (entities, @text, @ctx, @x=0, @y=0, fx=0, fy=0, @active = false) ->
      @images = _.filter entities, (e) -> e instanceof ImageEntity
      @type = "text"
      @vx = 0
      @vy = 0
      @applyForce(fx, fy)
      @ctx.font = "15pt Merriweather"
      @collided = false

    draw: (ctx) ->
      if @collided
        @explode(ctx)
        @expFrames ?= 0
        @expFrames++
        if @expFrames > 50
          @active = false
      else
        ctx.fillText(@text, @x, @y)

    # this doesn't work right now, needs to be a separate function
    explode: (ctx) ->
      ctx.beginPath()
      ctx.arc(@x, @y, 40, 2*Math.PI, false)
      ctx.fillStyle = "red"
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

        for image in @images
          xdiff = @x - image.x
          ydiff = @y - image.y
          if  0 < xdiff < image.img.width and 0 < ydiff < image.img.height
            @collided = true
