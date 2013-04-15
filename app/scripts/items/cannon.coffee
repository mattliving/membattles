define ["app", "items/imageItem"], (App, ImageItem) ->

  class Cannon extends ImageItem

    src: "/images/cannon.png"

    constructor: (options) ->
      super(options)
      {@mirrored, @axis} = options
      @mirrored ?= false

    draw: (ctx) ->
      if @loaded
        mirrorAxis = Math.round(@axis)
        ctx.save()
        ctx.translate(mirrorAxis, 0) #@pos.y)
        if @mirrored
          ctx.scale(-1, 1)
        ctx.translate(-mirroredAxis, 0)
        # x =
        # y =
        # ctx.drawImage(@img, 0, 0, @width, @height)
        super(ctx)
        ctx.restore()

    convertToRadians: (degree) ->
      return degree*(Math.PI/180);
