define [
  "helpers/vent",
  "items/physicsItem"
], (vent, PhysicsItem) ->

  class Letter extends PhysicsItem

    constructor: (options) ->
      super(options)
      {@letter, @text, @floor} = options

      @fontSize = 24
      @ctx.font = @fontSize + "pt 'Merriweather Sans'"
      @ctx.fillStyle = "#222"

      @width = @ctx.measureText(@letter).width
      @height = @fontSize

    draw: ->
      if @hitWord or @hitFloor
        @ctx.save()
        @ctx.translate(@pos.x+@width/2, @pos.y+@height/2)
        @ctx.rotate(@rotation)
        @ctx.fillText @letter, -@width/2, -@height/2
        @ctx.restore()
      else
        @ctx.fillText @letter, @pos.x, @pos.y


    update: (dx) ->
      if @rotating then @rotation += dx
      super(dx)

    checkCollision: ->
      if @pos.x > window.innerWidth or @pos.x < 0 or @pos.y > window.innerHeight
        @active = false

      if @hitWord
        # check if it's hit the ground - if so let it rest there
        dx = @pos.x - (@floor.pos.x - @floor.img.width/2)
        dy = @pos.y - (@floor.pos.y - @floor.img.height/2)
        if  0 < dx < @floor.img.width and 0 < dy < @floor.img.height
          @hitFloor = true
          @gravityOn = false
          @rotating = false
          @velocity = x: 0, y: 0
      else
        # check if it's hit/passed the text
        {x: lx, y: ly} = @pos
        {x: tx, y: ty} = @text.pos

        if ((lx + @width) > tx) and ((ly + @height) < (ty + @text.height))
          @hitWord = true
          @trigger 'collided'

    bounce: ->
      @gravityOn = true
      @rotating = true
      @rotation = 0
      @velocity = x: 0, y: 0
      @applyForce x: 1000*(Math.random()-0.5), y: 1000
