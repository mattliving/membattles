define ["app", "items/item"], (App, Item) ->

  class ImageItem extends Item

    constructor: (@x, @y, @scale, @active = false) ->
      super()
      @loaded = false
      @img = new Image()
      @img.src = @src
      @img.onload = => @loaded = true

    draw: (ctx) ->
      if @loaded
        ctx.drawImage(@img, @x, @y, @img.width*@scale, @img.height*@scale)
