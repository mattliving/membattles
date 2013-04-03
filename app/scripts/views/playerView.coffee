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
      "click .btn" : "toggleButton"

    regions: 
      courses: "#courses"

    initialize: ->
      @courses.on "show", (view) =>
        @listenTo view, "itemview:selected", (childView) =>
          @selectedCourse = childView

    onDomRefresh: ->
      @ui.btn.button()

    toggleButton: () ->
      if @selectedCourse
        @ui.btn.button("toggle")

