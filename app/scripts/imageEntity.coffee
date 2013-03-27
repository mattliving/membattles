define ["app", "entity"], (App, Entity) ->

  class ImageEntity extends Entity

    constructor: (@x, @y, @src, @scale, @active = false) ->
      @loaded = false
      @img = new Image()
      @img.src = @src
      @img.onload = () =>
        @loaded = true

    draw: (ctx) ->
      ctx.drawImage(@img, @x, @y, @img.width*@scale, @img.height*@scale)

    update: () ->
      