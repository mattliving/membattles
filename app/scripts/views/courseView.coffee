define ["marionette", "collections/thingusers"], 
(Marionette, Thingusers) ->
  
  class CourseView extends Marionette.ItemView
    
    tagName: "li"

    template: "#courseTemplate"
    
    events:
      click: "fetchThings"

    fetchThingusers: (e) ->
      @thingusers = new Thingusers()
      @thingusers.url += @model.get("id")
      @thingusers.fetch(
        success: =>
          console.log @thingusers
      )
      