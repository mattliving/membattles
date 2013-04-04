define [
  "marionette", 
  "vent", 
  "bootstrap.button"], 
(Marionette, vent) ->

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
        )

    onDomRefresh: ->
      @ui.btn.button()

    toggleReady: () ->
      if @selectedCourse
        @ui.btn.button("toggle")
        @model.ready()
        if @model.get("ready")
          @trigger("ready")
