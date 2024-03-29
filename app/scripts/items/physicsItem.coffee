define [
  "helpers/vent",
  "items/item"
],
(vent, Item) ->
  class PhysicsItem extends Item

    collided: false

    constructor: (options) ->
      super(options)
      {@frametime} = options
      @frametime ?= 1/100
      # @gravityOn is true if undefined or true in options, only false if false
      @gravityOn = options.gravityOn isnt false
      @applyForce(options.force)
      @velocity = x: 0, y: 0
      @dx = 0

    applyForce: (f = x: 0, y: 0) -> @force = x: f.x*0.0005, y: f.y*0.0005

    removeForces: -> @velocity = x: 0, y: 0

    update: (dx) ->
      @dx += dx
      while @dx > @frametime
        @velocity.x += @force.x
        @velocity.y += @force.y
        @pos.x  += @velocity.x
        @pos.y  += @velocity.y

        # the force applied will be 0 if gravity if off, else 9.8
        @applyForce x: 0, y: 9.8*@gravityOn

        @checkCollision()
        @dx -= @frametime

    checkCollision: ->
