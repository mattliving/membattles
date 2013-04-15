define [], ->

  class Timer

    constructor: ->
      @gameTime = 0
      @maxStep = 0.05
      @wallLastTimestamp = 0

    tick: ->
      wallCurrent = Date.now()
      wallDelta = (wallCurrent - @wallLastTimestamp) / 1000
      @wallLastTimestamp = wallCurrent

      gameDelta = Math.min(wallDelta, @maxStep)
      @gameTime += gameDelta
      return gameDelta
