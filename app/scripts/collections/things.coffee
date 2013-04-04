define ["app", "models/thing"],
(App, Thing) ->
  
  class Things extends Backbone.Collection

    url: "http://www.memrise.com/api/level/get/?level_id="

    model: Thing

    current: 0
    
    parse: (response) ->
      response.level.things

    getNext: -> @at(@current++)

    addText: (text) ->
      @push(text)
      @listenTo text, 'loaded', ->
        @unloaded--
        if @unloaded is 0
          @trigger "ready"
      @listenTo text, 'inactive', => @trigger 'next'
