define [
  "helpers/vent",
  "models/thing",
  "items/item",
],
(vent, Thing, Item) ->

  # displays a single text item
  class TextItem extends Item

    constructor: (options) ->
      super(options)
      {@model, @floor} = options
      @applyForce(options.force.x, options.force.y)
      @velocity = x: 0, y: 0
      @collided = @success = false
      # change this when we move to time based animation
      @expFrames = 0

    draw: (ctx) ->
      if @active
        ctx.font = "15pt 'Comic Sans MS'"
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

    applyForce: (fx, fy) -> @force = x: fx*0.0005, y: fy*0.0005

    # force based animation updates will need to be carefully updated when
    # we switch the animation code to time based
    update: (dx) ->
      if not @collided
        updates = Math.round(dx*200)
        while updates-- > 0 and not @collided
          @velocity.x += @force.x
          @velocity.y += @force.y
          @pos.x += @velocity.x
          @pos.y += @velocity.y

          @applyForce(0, 9.8)

          dx = @pos.x - (@floor.pos.x - @floor.img.width/2)
          dy = @pos.y - (@floor.pos.y - @floor.img.height/2)
          if  0 < dx < @floor.img.width and 0 < dy < @floor.img.height
            @success = false
            @collided = true
