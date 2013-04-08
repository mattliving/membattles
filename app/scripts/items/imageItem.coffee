define ["app", "items/item"], (App, Item) ->

  class ImageItem extends Item

    constructor: (@x, @y, @offset, @scale, @active = false) ->
      @loaded  = false
      @type    = "image"
      @img     = new Image()
      @img.src = @src
      @img.onload = =>
        @loaded = true

    draw: (ctx) ->
      if @loaded
        ctx.drawImage(@img, @x*@offset, @y, @img.width*@scale, @img.height*@scale)
