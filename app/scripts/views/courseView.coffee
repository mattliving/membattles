define ["marionette", "helpers/vent", "collections/things"],
(Marionette, vent, Thingusers) ->

  class CourseView extends Marionette.ItemView

    tagName: "li"

    template: "#courseTemplate"

    events:
      click: "toggleSelected"

    toggleSelected: () ->
      @$el.parent().children("li.active").removeClass "active"
      @$el.addClass "active"
      @trigger("selected")
