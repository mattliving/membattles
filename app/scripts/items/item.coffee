define [], () ->

  class Item
    _.extend(Item::, Backbone.Events)

    constructor: (options) ->
      {@pos, @active} = options
      # Item.items is a 'static' array attached to the class object.
      # By putting this into the constructor, all Items are added to it
      # on creation.
      Item.items.push @

    draw: (ctx) ->

    update: ->

  Item.items = []

  return Item
