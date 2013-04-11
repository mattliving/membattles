define [
  "marionette",
  "vent"],
(Marionette, vent) ->

  class PlayerLayout extends Marionette.Layout

    className: "media well"

    template: "#playerLayout"

    regions:
      player: "#player"
      courses: "#courses"

    initialize: ->
      @courses.on "show", (view) =>
        @listenTo view, "itemview:selected", (childView) =>
          @player.currentView.selectedCourse = childView.model
