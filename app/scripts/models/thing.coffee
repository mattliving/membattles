 define ["marionette"], (Marionette) ->

  class Thing extends Backbone.Model

    defaults:
      absolute_url: "/home/",
      pool_id: null,
      creator_id: null,
      attributes: {},
      id: null,
      columns: {}
      position: [0, 0]
      force:    [0, 0]
      velocity: [0, 0]
      collided: false
      loaded:   false
      active:   false
      success:  false

    parse: (thing) ->
      thing.text        = thing.columns["1"].val
      thing.translation = thing.columns["2"].val
      return thing

    initialize: ->
      @on "loaded", -> @set "loaded", true
      @on "collided", (success) ->
        @set "collided", true
        @set "success", success

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
        x  += vx
        y  += vy
        @set("velocity", [vx, vy])
        @set("position", [x, y])

        @applyForce(0, 9.8)

        floor = @get("floor")

        dx = x - floor.x
        dy = y - floor.y
        if  0 < dx < floor.img.width and 0 < dy < floor.img.height
          @trigger("collided", false)
