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
      if @pos.x > document.width or @pos.y > document.height
        @active = false

      {x: lx, y: ly} = @pos
      {x: tx, y: ty} = @text.pos
      # # this checks if it's hit or has passed the text; it's moving at high
      # # speed to may not actually collide
      # if ((lx + @width) > tx) and ((ly + @height) < (ty + @text.height))
      #   @collided = true
      #   @gravityOn = true
      #   @applyForce(x: -14000*Math.random(), y: 4000)

      dx = @pos.x - (@text.floor.pos.x - @text.floor.width/2)
      dy = @pos.y - (@text.floor.pos.y - @text.floor.height/2)
      if  0 < dx < @text.floor.width and 0 < dy < @text.floor.height
        # @collided = true
        @applyForce y: -@force.y
        @gravityOn = false
