define ["marionette", "collections/thingusers"], 
(Marionette, Thingusers) ->
  
  class CourseView extends Marionette.ItemView
    
    tagName: "li"

    template: "#courseTemplate"
    
    events:
      click: "fetchThingusers"

    fetchThingusers: (e) ->
      @thingusers = new Thingusers()
      @thingusers.url += @model.get("id")
      @thingusers.fetch(
        success: =>
          console.log @thingusers
      )
      
  CourseView