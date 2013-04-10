define [
  "marionette",
  "vent",
  "collections/things",
  "bootstrap.button"],
(Marionette, vent, Things) ->

  class PlayerView extends Marionette.Layout

    className: "media well"

    template: "#playerTemplate"

    ui: btn: ".btn"

    events:
      "click .btn" : "readyClick"

    regions:
      courses: "#courses"

    initialize: ({@disabled}) ->
      @model.on 'change', @render, @
      @courses.on "show", (view) =>
        @listenTo view, "itemview:selected", (childView) =>
          @selectedCourse = childView

      @on 'fetch:data', @getCourseModel, @

    onDomRefresh: ->
      @ui.btn.button()

    readyClick: (e) ->
      e.preventDefault()
      if @selectedCourse and not @disabled
        @toggleReady()

    toggleReady: ->
      @ui.btn.button("toggle")
      @model.ready()
      if @model.get("ready")
        @trigger("ready")

    getCourseModel: ->
      @selectedCourse.model.url = @selectedCourse.model.urlRoot + @selectedCourse.model.get("id")
      @selectedCourse.model.parse = (response) ->
        response.course

      @selectedCourse.model.fetch(
        success: (model) =>
          @trigger("course:fetched", (model))
      ).done =>
        @things = new Things()
        @things.url += @selectedCourse.model.get("levels")[0].id
        @things.fetch(
          success: (collection) =>
            @trigger("things:fetched", collection)
          )
