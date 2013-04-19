define ["app", "models/thing"],
(App, Thing) ->

  class Things extends Backbone.Collection

    url: "http://www.memrise.com/api/thingusers/waterable/?course_id="

    model: Thing

    current: 0

    parse: ({thingusers}) -> thingusers

    getNext: -> @at(@current++)

    getCurrent: -> @at(@current)

    addText: (text) ->
      @push(text)
      @listenTo text, 'loaded', ->
        @unloaded--
        if @unloaded is 0
          @trigger "ready"
      @listenTo text, 'inactive', => @trigger 'next'
