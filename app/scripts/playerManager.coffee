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

      @playerView.on "things:fetched", (@things) => @fetched = true

    initialize: (@floor) ->
      @playerView.on "things:fetched", =>
        @cannon = new Cannon(7, @floor.y-4, "/images/cannon.png", 50, 1.2, true)
        @cannon.mirrored = @local
        textPos = [@cannon.x, @cannon.y]
        fx = if @local then 2400 else -2400
        @textView = new TextView(@things, @floor, textPos, [fx, -3000])
