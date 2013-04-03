define ["app", "models/text"], (App, Text) ->
  
  class Texts extends Backbone.Collection
    model: Text
    
    url: ->
      "http://www.memrise.com/api/course/get/?course_id=#{@id}&levels_with_thing_ids=true"
    
    current: 0
    
    getNext: -> @get(@current++)

    addText: (text) ->
      @add(text)
      @listenTo text, 'inactive', => @trigger 'next'
      
    parse: ({course}) ->
      thing_ids = []
      for thing_id in course.levels[0].thing_ids
        thing_ids.push id: thing_id
      return thing_ids
