define ["app", "models/thing"],
(App, Thing) ->

  class Things extends Backbone.Collection

    url: "http://www.memrise.com/api/level/get/?with_content=true&level_id="

    model: Thing

    current: 0

    parse: ({level}) ->
      console.log level
      things = level.things
      for thing in things
        thing.a = level.column_a
        thing.b = level.column_b
      return things

    getNext: -> @at(@current++)

    addText: (text) ->
      @push(text)
      @listenTo text, 'loaded', ->
        @unloaded--
        if @unloaded is 0
          @trigger "ready"
      @listenTo text, 'inactive', => @trigger 'next'
