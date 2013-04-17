define [
  "marionette",
  "helpers/vent",
  "models/thing",
  "items/physicsItem",
  "items/letter",
  "items/explosion"
],
(Marionette, vent, Thing, PhysicsItem, Letter, Explosion) ->

  # displays a single text item
  class TextItem extends PhysicsItem

    constructor: (options) ->
      super(options)
      {@model, @floor} = options
      @success = false

      @fontSize = 24
      @ctx.font = @fontSize + "pt 'Merriweather Sans'"
      @ctx.fillStyle = "#222"

      @width = @ctx.measureText(@model.get("translation")).width
      @height = @fontSize

      # change this when we move to time based animation
      @expFrames = 0

    draw: ->
      if @collided
        @active = false
        @trigger("exploded", @model.get("text"), @success)
      else
        @ctx.fillText(@model.get("translation"), @pos.x, @pos.y)

    explode: ->
      letters = []
      startPos = @pos
      for letter, i in @model.get("translation").split('')
        letters.push new Letter
          letter: letter
          text: @
          floor: @floor
          pos:
            x: startPos.x + i * 30
            y: startPos.y
          force:
            x: (Math.random()-0.5)*1000
            y: -200

    update: (dx) ->
      unless @collided
        super(dx)

    checkCollision: ->
      dy = @pos.y - @floor.pos.y
      if 0 < dy < @floor.height
        @success = false
        @collided = true
