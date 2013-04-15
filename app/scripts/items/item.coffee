define ["backbone"], (Backbone) ->

  class Item
    _.extend(Item::, Backbone.Events)

    constructor: (options) ->
      {@pos} = options
      @ctx = Item.ctx
      @active = true
      Item.items.push @

    draw: (ctx) ->

    update: (dx) ->

  Item.items = []

  Item.setContext = (ctx) -> Item.ctx = ctx

  Item.draw = ->
    for item in Item.items
      item.draw()

  Item.update = (dx) ->
    for item in Item.items
      if item?.active
        item.update(dx)

    for item, i in Item.items
      unless item?.active
        Item.items.splice(i, 1)

  return Item
