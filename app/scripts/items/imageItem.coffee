define ["items/item"], (Item) ->

  class ImageItem extends Item

    constructor: (options) ->
      super(options)
      {@scale}    = options
      @scale     ?= 1
      @loaded     = false
      @img        = new Image()
      @img.src    = @src
      @img.onload = => @loaded = true

    draw: (ctx) ->
      if @loaded
        x = @pos.x - @img.width/2
        y = @pos.y - @img.height/2
        ctx.drawImage(@img, x, y, @img.width*@scale, @img.height*@scale)
