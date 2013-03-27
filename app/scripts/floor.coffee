define ["app", "item", "imageItem"], (App, Item, ImageItem) ->

  class Floor extends ImageItem

    draw: (ctx) ->
      if @loaded
        @scale = $("canvas")[0].width / @img.width
        ctx.drawImage(@img, @x, @y, @img.width*@scale, @img.height*@scale)
