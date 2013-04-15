define ["app", "items/imageItem"], (App, ImageItem) ->

  class Cannon extends ImageItem

    src: "/images/cannon.png"

    constructor: (options) ->
      super(options)
      {@mirrored} = options
      @mirrored ?= false

    draw: (ctx) ->
      if @loaded
        mirrorAxis = Math.round(@pos.x + @img.width/2)
        ctx.save()
        if @mirrored
          ctx.translate(mirrorAxis, @pos.y+@img.height/2)
          ctx.scale(-1, 1)
          ctx.translate(-mirrorAxis, 0)
        else
          ctx.translate(@pos.x, @pos.y+@img.height/2)
        ctx.rotate(@convertToRadians(-45))
        ctx.drawImage(@img, 0, 0, @img.width*@scale, @img.height*@scale)
        ctx.restore()

    convertToRadians: (degree) ->
      return degree*(Math.PI/180);
