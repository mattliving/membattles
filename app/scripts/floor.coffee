define ["app", "entity", "imageEntity"], (App, Entity, ImageEntity) ->

  class Floor extends ImageEntity

    draw: (ctx) ->
      if @loaded
        @scale = $("canvas")[0].width / @img.width
        ctx.drawImage(@img, @x, @y, @img.width*@scale, @img.height*@scale)
