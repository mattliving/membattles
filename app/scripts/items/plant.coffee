define ["app", "items/imageItem"], (App, ImageItem) ->

  class Plant extends ImageItem

    src: "images/medium_plant.png"

    constructor: (options) ->
      super(options)
      {@mirrored, @axis} = options
      @mirrored ?= false

    draw: ->
      if @loaded
        @ctx.save()
        if @mirrored
          @ctx.translate(@axis, 0)
          @ctx.scale(-1, 1)
          @ctx.translate(-@axis, 0)
        super(@ctx)
        @ctx.restore()
