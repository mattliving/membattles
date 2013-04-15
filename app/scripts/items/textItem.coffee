define [
  "helpers/vent",
  "models/thing",
  "items/physicsitem",
],
(vent, Thing, PhysicsItem) ->

  # displays a single text item
  class TextItem extends PhysicsItem

    constructor: (options) ->
      super(options)
      {@model, @floor} = options
      @success = false
      # change this when we move to time based animation
      @expFrames = 0

    draw: (ctx) ->
      ctx.font = "15pt 'Merriweather Sans'"
      ctx.fillStyle = "#222"
      if @collided
        @explode(ctx)
        @expFrames++
        if @expFrames > 50
          @active = false
          @trigger "inactive", @success
      else
        ctx.fillText(@model.get("translation"), @pos.x, @pos.y)

    explode: (ctx) ->
      lastFill = ctx.fillStyle
      ctx.beginPath()
      ctx.arc(@pos.x, @pos.y, 40, 2*Math.PI, false)
      ctx.fillStyle = if @success then "green" else "red"
      ctx.fill()
      ctx.fillStyle = lastFill

    update: (dx) ->
      unless @collided
        super(dx)

    checkCollision: ->
      dx = @pos.x - (@floor.pos.x - @floor.img.width/2)
      dy = @pos.y - (@floor.pos.y - @floor.img.height/2)
      if  0 < dx < @floor.img.width and 0 < dy < @floor.img.height
        @success = false
        @collided = true
