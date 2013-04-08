define [
  "vent",
  "items/plant",
  "items/cannon",
  "views/textView",
  "models/player",
  "views/playerView",
  "collections/courses",
  "views/coursesView"
],
(vent, Plant, Cannon, TextView, Player, PlayerView, Courses, CoursesView) ->

  class PlayerManager
    _.extend(PlayerManager::, Backbone.Events)

    constructor: (username, @local) ->
      pos                 = if @local then "left" else "right"
      @playerModel        = new Player username: username, position: pos
      # the things array should be moved from this guy into player manager
      @playerView         = new PlayerView model: @playerModel
      @playerCourses      = new Courses
      @playerCourses.url += @playerModel.get("username")

      @playerModel.fetch success: (model) =>
        model.set("photo_small", model.get("photo_small").replace("large", "small"))
        @trigger("model:fetched")

      @on 'view:rendered', ->
        @playerCourses.fetch success: (model) =>
          @playerCoursesView = new CoursesView(collection: @playerCourses)
          @playerView.courses.show(@playerCoursesView)

      @playerView.on "things:fetched", (@things) =>

    initialize: (@floor) ->
      if @local
        cPos = [40, @floor.y-4]
      else
        cPos = [600, @floor.y-4]
      @cannon = new Cannon(cPos[0], cPos[1], 1.2, true)
      @cannon.mirrored = not @local

      textPos = [@cannon.x+@cannon.img.width, @cannon.y]
      if @cannon.mirrored
        textPos[0] = 600 + textPos[0]

      fx = if @local then 2400 else -2400
      console.log fx
      @textView = new TextView(@things, @floor, textPos, [fx, -3000])

      # shh I'm listening for events
      @on 'next', ->
        console.log 'triggering next', @local
        @textView.trigger('next')

      @on 'guess', (guess) ->
        if @textView.model.get("active")
          correct = @textView.model.get("text") is guess
          console.log 'triggering endTurn with guess', guess, @local
          @textView.model.set "collided", true
          @textView.model.set "success", correct

      # firing ma events pew pew
      @listenTo @textView, 'inactive', (success) ->
        console.log 'triggering endTurn', @local
        @trigger 'endTurn', success
