define [
  "helpers/vent",
  "items/item"
],
(vent, Item) ->
  class PhysicsItem extends Item

    collided: false

    constructor: (options) ->
      super(options)
      @applyForce(options.force)
      @velocity = x: 0, y: 0

    applyForce: (f) -> @force = x: f.x*0.0005, y: f.y*0.0005

    update: (dx) ->
      updates = Math.round(dx*150)
      while updates-- > 0 and not @collided
        @velocity.x += @force.x
        @velocity.y += @force.y
        @pos.x  += @velocity.x
        @pos.y  += @velocity.y

        @applyForce x: 0, y: 9.8

        @checkCollision()

    checkCollision: ->
