define ["app", "models/thing"],
(App, Thing) ->

  class Things extends Backbone.Collection

    url: "http://www.memrise.com/api/things/waterable/?course_id="

    model: Thing

    current: 0

    parse: ({things}) -> things

    getNext: -> @at(@current++)

    getCurrent: -> @at(@current)

    addText: (text) ->
      @push(text)
      @listenTo text, 'loaded', ->
        @unloaded--
        if @unloaded is 0
          @trigger "ready"
      @listenTo text, 'inactive', => @trigger 'next'
