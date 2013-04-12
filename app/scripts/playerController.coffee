define [
  "marionette",
  "helpers/vent",
  "items/plant",
  "items/cannon",
  "models/player",
  "collections/courses",
  "views/playerLayout",
  "views/playerView",
  "views/coursesView",
  "views/textView"
],
(Marionette, vent, Plant, Cannon, Player, Courses, PlayerLayout, PlayerView, CoursesView, TextView) ->

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
        # hacky way of not showing the ready button if the other user is ready on load
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
      # more permanent solution to this is needed.
      cPos =
        x: if @local then 600 else 40
        y: @floor.pos.y-4
      @cannon = new Cannon
        pos: cPos
        scale: 1.2
        mirrored: @local
        active: true

      textPos = [@cannon.pos.x+@cannon.img.width, @cannon.pos.y]
      if @cannon.mirrored
        textPos[0] += 600 # probably just chance that this is the right num

      fx = if @local then -2400 else 2400
      @textView = new TextView
        collection: @things
        floor: @floor
        startPosition: textPos 
        startForce: [fx, -3000]
        active: true

      @on 'next', ->
        @playerView.model.setCurrentPlayer()
        @textView.trigger('next')

      @on 'guess', (guess) ->
        if @textView.model.get("active")
          @textView.model.set "success", @textView.model.checkAnswer(guess)
          @textView.model.set "collided", true

      @listenTo @textView, 'inactive', (success) ->
        @trigger 'endTurn', success

      @on 'endTurn', (success) ->
        model = @playerView.model
        @playerView.model.setCurrentPlayer()
        unless success
          model.decLives()
          if model.get('lives') <= 0
            vent.trigger 'game:ending', model.get('username')
        else
          model.incPoints()

