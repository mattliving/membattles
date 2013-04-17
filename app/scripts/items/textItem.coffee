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

    draw: ->
      if @collided
        if @success
          @animatePoints()
          @explode()
        else
          new Explosion pos: _.clone @pos
        @trigger("exploded", @model.get("text"))
        @active = false
        @trigger "inactive", @success
      else
        @ctx.fillText(@model.get("translation"), @pos.x, @pos.y)

    explode: ->
      letters  = []
      startPos = @pos
      randX    = Math.random() * (18000 - 16000) + 16000;
      randY    = Math.random() * (6000 - 4000) + 4000;
      chars    = @model.get("translation").split('')
      center   = chars.length/2
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

    animatePoints: ->
      $curPoints = $("#thisPlayer #points")
      $points    = $("<div></div>")
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
        "font-size": "73.5px"
      ).animate(
        top:    $curPoints[0].offsetTop + $curPoints[0].offsetHeight/4
        left:   $curPoints[0].offsetLeft + $curPoints[0].offsetWidth/4
        'font-size': "24.5px",
        1000,
        "swing",
        ->
          $points.remove()
      )

    update: (dx) ->
      unless @collided
        super(dx)

    checkCollision: ->
      dy = @pos.y - @floor.pos.y
      if 0 < dy < @floor.height
        @success = false
        @collided = true
