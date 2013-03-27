define ["app"], (App) ->

  class Player

    constructor: (@x, @y) ->
      @garden = {}
      @mediumPlants = 0
      @largePlants = 0