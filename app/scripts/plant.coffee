define ["app", "imageEntity"], (App, ImageEntity) ->

  class Plant extends ImageEntity

    draw: (ctx) ->
      if @loaded
        @width  = @img.width*@scale
        @height = @img.height*@scale
        ctx.drawImage(@img, @x*@width*@offset, @y, @width, @height)