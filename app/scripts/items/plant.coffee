define ["app", "items/imageItem"], (App, ImageItem) ->

  class Plant extends ImageItem

    draw: ->
      if @loaded
        @width  = @img.width*@scale
        @height = @img.height*@scale
        @ctx.drawImage(@img, @x*@width, @y, @width, @height)
