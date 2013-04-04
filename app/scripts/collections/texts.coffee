define ["app", "models/text"], (App, Text) ->
  
  class Texts extends Backbone.Collection
    model: Text
    
    url: ->
      "http://www.memrise.com/api/course/get/?course_id=#{@id}&levels_with_thing_ids=true"
    
    current: 0
    
    getNext: -> @at(@current++)

    addText: (text) ->
      @push(text)
      @listenTo text, 'loaded', ->
        @unloaded--
        if @unloaded is 0
          @trigger "ready"
      @listenTo text, 'inactive', => @trigger 'next'
