define [
  "helpers/vent",
  "models/thing",
  "items/letter",
  "items/physicsitem"
],
(vent, Thing, Letter, PhysicsItem) ->

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
        @explode()
        @active = false
        @trigger "inactive", @success
      else
        @ctx.fillText(@model.get("translation"), @pos.x, @pos.y)

    explode: ->
      letters = []
      startPos = @pos
      for letter, i in @model.get("text").split('')
        letters.push new Letter
          letter: letter
          text: @
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
      dx = @pos.x - (@floor.pos.x - @floor.img.width/2)
      dy = @pos.y - (@floor.pos.y - @floor.img.height/2)
      if  0 < dx < @floor.img.width and 0 < dy < @floor.img.height
        @success = false
        @collided = true
