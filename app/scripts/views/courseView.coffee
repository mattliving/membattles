define ["marionette", "vent", "collections/things"], 
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

    fetchThings: () ->
      @things = new Things()
      @things.url += @model.get("id")
      @things.fetch(
        success: =>
          console.log @things
      )
