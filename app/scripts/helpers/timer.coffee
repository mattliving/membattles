define [], ->

  class Timer

    constructor: ->
      @gameTime = 0
      @maxStep = 0.05
      @wallLastTimestamp = 0

    tick: ->
      if @wallLastTimestamp is 0 then @wallLastTimestamp = Date.now()
      wallCurrent = Date.now()
      wallDelta = (wallCurrent - @wallLastTimestamp) / 1000
      @wallLastTimestamp = wallCurrent

      gameDelta = wallDelta # Math.min(wallDelta, @maxStep)
      @gameTime += gameDelta
      return gameDelta
