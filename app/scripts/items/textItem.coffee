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
        new Explosion pos: _.clone @pos
        if @success
          @animatePoints()
        else
          @trigger("exploded", @model.get("text"))
          @explode()
        @active = false
        @trigger "inactive", @success
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

    animatePoints: ->
      $curPoints = $("#thisPlayer #points")
      $points    = $("<div><h3></h3></div>")
      $("#game").append($points)
      $points.text "+45"
      $points.css
        position: "absolute",
        top:    $("canvas")[0].offsetTop + @pos.y + "px",
        left:   $("canvas")[0].offsetLeft + @pos.x + "px",
        "text-align": "center";
        "vertical-align": "center";
        "font-family": "Helvetica Neue";
        "font-size": "49px";
        "z-index": 1,
        color: "#333"
      $points.animate(
        top:    $curPoints[0].offsetTop + 25
        left:   $curPoints[0].offsetLeft + 30
        'font-size': "24.5px",
        1000,
        "swing",
        -> $points.remove()
      )

    update: (dx) ->
      unless @collided
        super(dx)

    checkCollision: ->
      dy = @pos.y - @floor.pos.y
      if 0 < dy < @floor.height
        @success = false
        @collided = true
