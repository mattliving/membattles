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
      {@model, @floor, @target} = options
      timing = @model.getTiming()
      options.frametime = 0.001*timing/680 # 680 is the number of frames
      super(options)
      @success = false

      @fontSize = 24
      @ctx.font = @fontSize + "pt 'Merriweather Sans'"
      @ctx.fillStyle = "#222"

      @width  = @ctx.measureText(@model.get("translation")).width
      @height = @fontSize

    draw: ->
      if @collided
        @active = false
        if @collidedType is "guess"
          new Explosion pos: _.clone @pos
        else if @collidedType is "floor"
          new Explosion pos: _.clone @target
        if @success then @explode()
        @trigger("exploded", @model.get("text"), @success)
      else
        @ctx.fillText(@model.get("translation"), @pos.x, @pos.y)

    explode: ->
      randX    = Math.random() * (18000 - 16000) + 16000;
      randY    = Math.random() * (8000 - 4000) + 4000;
      chars    = @model.get("translation").split('')
      center   = chars.length/2
      letters  = []
      startPos = @pos
      for letter, i in chars
        letters.push new Letter
          letter: letter
          text: @
          floor: @floor
          pos:
            x: startPos.x + i * 30
            y: startPos.y
          force:
            x: if i > center then randX else -randX
            y: (Math.random()-0.5) * randY
          gravityOn: false

    update: (dx) ->
      unless @collided
        super(dx)

    checkCollision: ->
      dy = @pos.y - @floor.pos.y
      if 0 < dy < @floor.height
        @success = false
        @collidedType = "floor"
        @collided = true
