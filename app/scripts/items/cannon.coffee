define ["app", "items/imageItem"], (App, ImageItem) ->

  class Cannon extends ImageItem

    src: "/images/cannon.png"

    mirrored: false

    draw: (ctx) ->
      if @loaded
        mirrorAxis = Math.round(@x + @img.width/2)
        ctx.save()
        if @mirrored
          ctx.translate(mirrorAxis, @y+@img.height)
          ctx.scale(-1, 1)
          ctx.translate(-mirrorAxis, 0)
        else
          ctx.translate(@x, @y+@img.height)
        ctx.rotate(@convertToRadians(-45))
        ctx.drawImage(@img, 0, 0, @img.width*@scale, @img.height*@scale)
        ctx.restore()

    convertToRadians: (degree) ->
      return degree*(Math.PI/180);
