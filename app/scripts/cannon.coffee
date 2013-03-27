define ["app", "imageEntity"], (App, ImageEntity) ->

  class Cannon extends ImageEntity

    draw: (ctx) ->
      if @loaded
        ctx.save()
        ctx.translate(@x*@offset, @y+@img.height/2)
        ctx.rotate(@convertToRadians(-45))
        ctx.drawImage(@img, 0, 0, @img.width*@scale, @img.height*@scale)
        ctx.restore()

    convertToRadians: (degree) ->
      return degree*(Math.PI/180);