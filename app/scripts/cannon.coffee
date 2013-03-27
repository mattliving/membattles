define ["app", "imageItem"], (App, ImageItem) ->

  class Cannon extends ImageItem

    draw: (ctx) ->
      if @loaded
        ctx.save()
        ctx.translate(@x*@offset, @y+@img.height)
        ctx.rotate(@convertToRadians(-45))
        ctx.drawImage(@img, 0, 0, @img.width*@scale, @img.height*@scale)
        ctx.restore()

    convertToRadians: (degree) ->
      return degree*(Math.PI/180);