define [
  "helpers/vent",
  "items/item"
],
(vent, Item) ->
  class PhysicsItem extends Item

    collided: false

    constructor: (options) ->
      super(options)
      # @gravityOn is true if undefined or true in options, false if false
      @gravityOn = options.gravityOn isnt false
      @applyForce(options.force)
      @velocity = x: 0, y: 0

    applyForce: (f) -> @force = x: f.x*0.0005, y: f.y*0.0005

    update: (dx) ->
      # fix this as adam has said - store a difference rather than an
      # absolute count
      updates = Math.round(dx*150)
      while updates-- > 0
        @velocity.x += @force.x
        @velocity.y += @force.y
        @pos.x  += @velocity.x
        @pos.y  += @velocity.y

        # the force applied will be 0 if gravity if off, else 9.8
        @applyForce x: 0, y: 9.8*@gravityOn

        @checkCollision()

    checkCollision: ->
