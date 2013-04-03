define ["app"], (App) ->

  class Text extends Backbone.Model
    
      defaults:
        position: [0, 0]
        force:    [0, 0]
        velocity: [0, 0]
        collided: false
        loaded:   false
        active:   false  
        success:  false
    
    url: ->
      "http://www.memrise.com/api/thing/get/?thing_id=#{@get('id')}"
    
    parse: (data) ->
      console.log data
      columns = data.thing.columns
      return {
        text: columns["1"].val
        translation: columns["2"].val
      }
    
    activate: ->
      @set("active", true)
      @trigger("active")
    
    deactivate: ->
      @set("active", false)
      @trigger("inactive")
    
    applyForce: (fx, fy) -> @set("force", [fx*0.0005, fy*0.0005])
    
    update: ->
      [fx, fy] = @get("force")
      [vx, vy] = @get("velocity")
      [x,  y ] = @get("position")
      
      if not @get("collided")
        vx += fx
        vy += fy
        x += vx
        y += vy
        @applyForce(0, 9.8)
      
        @set("force", [fx, fy])
        @set("velocity", [vx, vy])
        @set("position", [x, y])