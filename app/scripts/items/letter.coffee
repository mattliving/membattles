define [
  "helpers/vent",
  "items/physicsitem"
], (vent, PhysicsItem) ->

  class Letter extends PhysicsItem

    constructor: (options) ->
      super(options)
      {@letter} = options

    draw: (ctx) ->
      ctx.fillText @letter, @pos.x, @pos.y

    checkCollision: ->
      # this should check against text objects only
      # text objects will need to have bounding boxes for this to work
      # may also have to make moments work for rotation, might be overkill
