define [
  "marionette",
  "vent",
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
        @playerLayout.player.show(@playerView)

      @on 'view:rendered', ->
        @playerCoursesView.collection.fetch success: (model) =>
          @playerLayout.courses.show(@playerCoursesView)

      @on 'ready', ->
        @playerView.model.set("ready", true)
        @playerCoursesView.collection.reset(@playerView.selectedCourse)

    initialize: (@floor) ->
      # more permanent solution to this is needed.
      if @local
        cPos = [600, @floor.y-4]
      else
        cPos = [40, @floor.y-4]
      @cannon = new Cannon(cPos[0], cPos[1], 1.2, true)
      @cannon.mirrored = @local

      textPos = [@cannon.x+@cannon.img.width, @cannon.y]
      if @cannon.mirrored
        textPos[0] += 600 # probably just chance that this is the right num

      fx = if @local then -2400 else 2400
      @textView = new TextView(@things, @floor, textPos, [fx, -3000])

      @on 'next', ->
        @playerView.model.setCurrentPlayer()
        @textView.trigger('next')

      @on 'guess', (guess) ->
        if @textView.model.get("active")
          correct = @textView.model.get("text") is guess
          @textView.model.set "collided", true
          @textView.model.set "success", correct

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

