define [
  "helpers/vent",
  "items/physicsitem"
], (vent, PhysicsItem) ->

  class Letter extends PhysicsItem

    constructor: (options) ->
      super(options)
      {@letter, @text} = options

      @fontSize = 24
      @ctx.font = @fontSize + "pt 'Merriweather Sans'"
      @ctx.fillStyle = "#222"

      @width = @ctx.measureText(@letter).width
      @height = @fontSize

    draw: ->
      @ctx.fillText @letter, @pos.x, @pos.y

    checkCollision: ->
      if @pos.x > window.innerWidth or @pos.x < 0 or @pos.y > window.innerHeight
        @active = false

      {x: lx, y: ly} = @pos
      {x: tx, y: ty} = @text.pos

      # this checks if it's hit or has passed the text; it's moving at high
      # speed to may not actually collide
      if ((lx + @width) > tx) and ((ly + @height) < (ty + @text.height))
        @collided = true
        @trigger 'collided'

    bounce: ->
      @gravityOn = true
      @applyForce x: -14000*Math.random(), y: 4000

    explode: ->
      @velocity = x: 0, y: 0
      @applyForce x: 0, y: 0
