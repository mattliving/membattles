define ["app", "imageItem"], (App, ImageItem) ->

  class Cannon extends ImageItem

    constructor: (@x, @y, @src, @offset, @scale, @mirrored, @active = false) ->
      @loaded = false
      @type = "image"
      @img = new Image()
      @img.src = @src
      @img.onload = =>
        @loaded = true

      @text = []
      @currentText = 0
      @on "nextText", ->
        if @currentText < @text.length
          console.log "activating next" + (+@mirrored + 1)
          @text[@currentText++].activate()

    addText: (text) ->
      text.x = @x*@offset+60
      text.y = @y
      if @mirrored then text.x = canvas.width - text.x
      @text.push text
      @listenTo text, "inactive", =>
        @trigger("exploded")

    draw: (ctx) ->
      if @loaded
        mirrorAxis = Math.round(@x*@offset + @img.width/2)
        ctx.save()
        if @mirrored
          ctx.translate(mirrorAxis, @y+@img.height)
          ctx.scale(-1, 1)
          ctx.translate(-mirrorAxis, 0)
        else
          ctx.translate(@x*@offset, @y+@img.height)
        ctx.rotate(@convertToRadians(-45))
        ctx.drawImage(@img, 0, 0, @img.width*@scale, @img.height*@scale)
        ctx.restore()

    convertToRadians: (degree) ->
      return degree*(Math.PI/180);
