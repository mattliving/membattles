define ["app"], (App) ->

  class Item
    _.extend(Item::, Backbone.Events)

    constructor: ->
      Item.items.push @

    draw: (ctx) ->

    update: ->

  Item.items = []

  return Item
