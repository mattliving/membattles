define [
  "marionette", 
  "vent",
  "collections/things", 
  "bootstrap.button"], 
(Marionette, vent, Things) ->

  class PlayerView extends Marionette.Layout

    className: "media well"
        
    template: "#playerTemplate"

    ui: 
      btn: ".btn"
  
    events: 
      "click .btn" : "toggleReady"

    regions: 
      courses: "#courses"

    initialize: ->
      @courses.on "show", (view) =>
        @listenTo view, "itemview:selected", (childView) =>
          @selectedCourse = childView

      vent.on "game:starting", =>
        @selectedCourse.model.url = @selectedCourse.model.urlRoot + @selectedCourse.model.get("id")
        @selectedCourse.model.parse = (response) ->
          response.course

        @selectedCourse.model.fetch(
          success: (model) ->
            vent.trigger("course:fetched")
        ).done () =>
          @things = new Things()
          @things.url += @selectedCourse.model.get("levels")[0].id
          @things.fetch(
            success: (collection) ->
              vent.trigger("things:fetched", collection)
            )

    onDomRefresh: ->
      @ui.btn.button()

    toggleReady: () ->
      if @selectedCourse
        @ui.btn.button("toggle")
        @model.ready()
        if @model.get("ready")
          @trigger("ready")
