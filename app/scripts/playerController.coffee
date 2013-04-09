define [
  "marionette",
  "vent",
  "items/plant",
  "items/cannon",
  "views/textView",
  "models/player",
  "views/playerView",
  "collections/courses",
  "views/coursesView"
],
(Marionette, vent, Plant, Cannon, TextView, Player, PlayerView, Courses, CoursesView) ->

  class PlayerController extends Marionette.Controller

    constructor: (username, @local) ->
      pos                 = if @local then "left" else "right"
      @playerModel        = new Player username: username, position: pos
      @playerView         = new PlayerView model: @playerModel, disabled: not @local
      @playerCourses      = new Courses
      @playerCourses.url += @playerModel.get("username")

      @playerModel.fetch success: (model) =>
        model.set("photo_small", model.get("photo_small").replace("large", "small"))
        @trigger("model:fetched")

      @on 'view:rendered', ->
        @playerCourses.fetch success: (model) =>
          @playerCoursesView = new CoursesView(collection: @playerCourses)
          @playerView.courses.show(@playerCoursesView)

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

      fx = if @local then 2400 else -2400
      @textView = new TextView(@things, @floor, textPos, [fx, -3000])

      # only used by the socket connection
      @on 'ready', ->
        @playerView.courses.close()
        @playerView.toggleReady()

      @on 'next', ->
        @textView.trigger('next')

      @on 'guess', (guess) ->
        if @textView.model.get("active")
          correct = @textView.model.get("text") is guess
          @textView.model.set "collided", true
          @textView.model.set "success", correct

      @listenTo @textView, 'inactive', ->
        @trigger 'endTurn'

      @on 'endTurn', ->
        model = @playerView.model
        unless model.get('success')
          lives = model.get('lives')
          @playerView.model.set('lives', lives-1)
          unless lives > 0
            vent.trigger 'game:ending'
        else
          model.set('points', model.get('points')+45)

