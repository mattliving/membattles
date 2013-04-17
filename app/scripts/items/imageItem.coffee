define ["items/item"], (Item) ->

  class ImageItem extends Item

    constructor: (options) ->
      super(options)
      {@scaleX, @scaleY} = options
      @loaded  = false
      @img     = new Image()
      @img.src = @src
      @img.onload = =>
        @loaded = true
        @scaleX ?= @img.width
        @scaleY ?= @img.height
        @width  = @img.width * (@scaleX / @img.width)
        @height = @img.height / @img.width * @width

    draw: ->
      if @loaded
        x = @pos.x - @width/2
        y = @pos.y - @height/2
        @ctx.drawImage(@img, x, y, @width, @height)
