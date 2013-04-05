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
      pos            = if @local then "left" else "right"
      @playerModel   = new Player username: username, position: pos
      @playerView    = new PlayerView model: @playerModel
      @playerCourses = new Courses
      @playerCourses.url += @playerModel.get("username")

      @playerModel.fetch success: (model) =>
        model.set("photo_small", model.get("photo_small").replace("large", "small"))
        @trigger("model:fetched")

      @on 'view:rendered', ->
        @playerCourses.fetch success: (model) =>
          @playerCoursesView = new CoursesView(collection: @playerCourses)
          @playerView.courses.show(@playerCoursesView)

    initialize: ->

