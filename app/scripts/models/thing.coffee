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
      accept = thing.columns[thing.a].accepted
      for alt in thing.columns[thing.a].alts
        accept.push alt.val
      accept.push thing.columns[thing.a].val
      _.extend thing,
        text: thing.columns[thing.a].val
        translation: thing.columns[thing.b].val
        accept: accept

    initialize: ->
      @on "loaded", -> @set "loaded", true

    activate: ->
      @set("active", true)

    deactivate: ->
      @set("active", false)

    # this code has been copied from the memrise js, but doesn't use XRegExp
    # memoize caches output results
    sanitizeInput: _.memoize (text) ->
      # Remove parenthetical expressions e.g. dog (male)
      text = text.replace(/\([^\)]*\)/g, "")

      # Remove all punctuation
      text = text.replace(/['";:,.\/?\\-]/g, "")

      # Replace all whitespace with one space
      text = text.replace(/\s+/g, " ")

      # could add this in again later, unnecessary for now
      # Remove all ignorable characters
      # text = text.replace(untypeable_re, '', 'all')
      # text = text.replace(arabic_ignorable_re, '', 'all')

      # Lower case
      text = text.toLowerCase()

      # simple trim shim, probably unnecessary
      if not String::trim then String::trim -> @replace /^\s+|\s+$/g, ''

      text = text.trim()

      return text

    checkAnswer: (text) -> @sanitizeInput(text) in @get("accept")

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
          @set "success", false
          @set "collided", true
