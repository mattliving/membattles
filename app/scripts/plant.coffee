define ["app", "imageEntity"], (App, ImageEntity) ->

  class Plant extends ImageEntity

    draw: (ctx) ->
      @width  = @img.width*@scale
      @height = @img.height*@scale
      @offset = 1.1
      ctx.drawImage(@img, @x*@width*@offset, @y, @width, @height)