define ["app"], (App) ->

  class Item
    _.extend(Item::, Backbone.Events)

    constructor: (@x, @y) ->

    draw: (ctx) ->

    update: () ->
