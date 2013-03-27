define ["app", "entity"], (App, Entity) ->

  class ImageEntity extends Entity

    constructor: (@x, @y, @src, @active = false) ->
      @loaded = false
      @type = "image"
      @img = new Image()
      @img.src = @src
      @img.onload = () =>
        @loaded = true

    draw: (ctx) ->
      ctx.drawImage(@img, @x, @y, @img.width*0.3, @img.height*0.3)
