define ["app", "entity"], (App, Entity) ->

  class ImageEntity extends Entity

    constructor: (@x, @y, @src, @scale, @active = false) ->
      @loaded = false
      @type = "image"
      @img = new Image()
      @img.src = @src
      @img.onload = =>
        @loaded = true

    draw: (ctx) ->
      if @loaded
        ctx.drawImage(@img, @x, @y, @img.width*@scale, @img.height*@scale)
