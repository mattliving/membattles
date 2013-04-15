define ["backbone"], (Backbone) ->

  class Item
    _.extend(Item::, Backbone.Events)

    constructor: (options) ->
      {@pos} = options
      @active = true
      Item.items.push @

    draw: (ctx) ->

    update: (dx) ->

  Item.items = []

  Item.draw = (ctx) ->
    for item in Item.items
      item.draw(ctx)

  Item.update = (dx) ->
    for item in Item.items
      if item?.active
        item.update(dx)

    for item, i in Item.items
      unless item?.active
        Item.items.splice(i, 1)

  return Item
