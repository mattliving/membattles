define ["app", "models/thing"],
(App, Thing) ->

  class Things extends Backbone.Collection

    url: "http://www.memrise.com/api/thinguser/waterable/?course_id="

    model: Thing

    current: 0

    parse: (data) ->
      if data.thingusers then return data.thingusers

      thingusers = []
      things = data.level.things
      for thing in things
        thingusers.push
          thing: thing
          column_a: data.level.column_a
          column_b: data.level.column_b
      return thingusers

    getNext: -> @at(@current++)

    getCurrent: -> @at(@current)

    addText: (text) ->
      @push(text)
      @listenTo text, 'loaded', ->
        @unloaded--
        if @unloaded is 0
          @trigger "ready"
      @listenTo text, 'inactive', => @trigger 'next'

    comparator: -> Math.random()
