define ["app", "entity", "imageEntity"], (App, Entity, ImageEntity) ->

  class ImageEntity extends Entity

    constructor: (@x, @y, @src, @offset, @scale, @active = false) ->
      @loaded = false
      @type = "image"
      @img = new Image()
      @img.src = @src
      @img.onload = =>
        @loaded = true

    draw: (ctx) ->
      if @loaded
        ctx.drawImage(@img, @x*@offset, @y, @img.width*@scale, @img.height*@scale)
