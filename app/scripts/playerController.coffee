define [
  "marionette",
  "helpers/vent",
  "models/player",
  "collections/courses",
  "views/playerLayout",
  "views/playerView",
  "views/coursesView",
  "items/cannon",
  "items/textItem",
  "items/letter",
  "items/plant",
  "items/explosion"
],
(Marionette, vent, Player, Courses, PlayerLayout, PlayerView, CoursesView, Cannon, TextItem, Letter, Plant, Explosion) ->

  class PlayerController extends Marionette.Controller

    constructor: (username, @local) ->
      pos                = if @local then "left" else "right"
      @playerModel       = new Player username: username, position: pos
      @playerLayout      = new PlayerLayout()
      @playerView        = new PlayerView model: @playerModel, disabled: not @local
      @playerCoursesView = new CoursesView(collection: new Courses())
      @playerCoursesView.collection.url += @playerModel.get("username")

      @playerModel.fetch success: (model) =>
        model.set("photo_small", model.get("photo_small").replace("large", "small"))
        @trigger("model:fetched")
        if @ready then @playerView.off("show")
        @playerLayout.player.show(@playerView)

      @on 'view:rendered', ->
        unless @ready
          @playerCoursesView.collection.fetch success: (model) =>
            @playerLayout.courses.show(@playerCoursesView)
        else
          @playerLayout.courses.show(@playerCoursesView)

      @on 'ready', ->
        @ready = true
        @playerCoursesView.collection.reset(@playerView.selectedCourse)

    initialize: (@floor) ->

      @cannon = new Cannon
        axis: @floor.pos.x
        pos:
          x: @floor.pos.x*0.4
          y: @floor.pos.y-10
        active: true
        mirrored: @local

      @initPlants()

      @spawnPos = y: @cannon.pos.y - @cannon.img.height - 100
      if @local
        @spawnPos.x = 2*@cannon.axis-@cannon.pos.x
      else
        @spawnPos.x = @cannon.pos.x

      @on 'next', ->
        # inactive items will be removed from the items array
        @currentTextItem?.active = false

        # create the new text item at the mouth of the cannon
        if (model = @things.getNext())?
          @currentTextItem = new TextItem
            pos: _.clone @spawnPos
            target:
              x: if @local then @plants[0].pos.x else $("canvas").width() - @plants[0].pos.x
              y: @plants[0].pos.y
            force:
              x: if @local then -2400 else 2400
              y: -3000
            active: true
            floor: @floor
            model: model

          @listenTo @currentTextItem, 'exploded', (text, success) =>
            if success then @animatePoints()
            @trigger 'exploded', text, success
            @trigger 'endTurn', success

          @playerView.model.setCurrentPlayer()
        else vent.trigger 'game:ending'

      @on 'guess', (guess) ->
        if @currentTextItem.active
          @currentTextItem.success  = @currentTextItem.model.checkAnswer(guess)
          @currentTextItem.collided = true
          @currentTextItem.collidedType = "guess"

      @on 'endTurn', (success) ->
        model = @playerView.model
        model.setCurrentPlayer()
        unless success
          model.decLives()
          @plants[0]?.active = false
          @plants.shift()
          if model.get('lives') <= 0
            vent.trigger 'game:ending'
        else
          model.incPoints(45)

    initPlants: ->
      @plants = []
      for i in [1..@playerModel.get("lives")]
        @plants.push new Plant
          pos:
            x: @cannon.pos.x - (i+1)*60
            y: @cannon.pos.y
          axis: @floor.pos.x
          mirrored: not @local
          active: true

    getData: ->
      text: @currentTextItem.model.get("text")
      translation: @currentTextItem.model.get("translation")

    animatePoints: ->
      $curPoints = if @local then $("#thisPlayer #points") else $("#thatPlayer #points")
      $points    = $("<div><h3></h3></div>")
      $("#game").append($points)
      $points.text "+45"
      $points.css
        position: "absolute",
        top:  $("canvas").offset().top + @currentTextItem.pos.y + "px",
        left: $("canvas").offset().left + @currentTextItem.pos.x + "px",
        "text-align": "center";
        "vertical-align": "center";
        "font-family": "Helvetica Neue";
        "font-weight": "bold";
        "font-size": "49px";
        "z-index": 1,
        color: "#333"
      $points.animate
        "font-size": "73.5px"
      .animate
        top:  $curPoints.offset().top + 10
        left: $curPoints.offset().left + 11
        'font-size': "24.5px",
        1000,
        "swing",
        -> $points.remove()

    # no longer used :(
    fireLetter: (letter, input, startPos) ->
      # these are used to calculate the force needed to make it go to the word
      # TODO: make it move to where the word will be, rather than where it is
      {x: tx, y: ty} = @currentTextItem.pos
      {x: sx, y: sy} = startPos
      letter = new Letter
        pos: x: sx, y: sy
        force: x: 70*(tx-sx), y: 70*(ty-sy)
        gravityOn: false
        letter: letter
        text: @currentTextItem
        floor: @floor
      letter.on 'collided', =>
        if @currentTextItem.model.checkPartialAnswer(input)
          new Explosion pos: _.clone letter.pos
          letter.active = false
        else
          letter.bounce()
