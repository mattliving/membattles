define [
  "helpers/vent",
  "items/item"
],
(vent, Item) ->

  class Explosion extends Item
    constructor: (options) ->
      super(options)
      @dx = 0
      @images = []
      @frame = 0
      @loaded = false
      @loadCount = 0
      for i in [0..10]
        img = new Image()
        img.src = "images/explosion#{i}.png"
        img.onload = =>
          @loadCount++
          if @loadCount is 10 then @trigger('loaded')
        @images.push img

      @on 'loaded', ->
        @loaded = true
        @width = @images[0].width
        @height = @images[0].height

    draw: ->
      if @loaded and @frame < @images.length
        @ctx.drawImage(@images[@frame], @pos.x-@width/2, @pos.y-@height/2)

    update: (dx) ->
      @dx += dx
      if @dx > 0.05
        @frame++
        if @frame >= @images.length
          @active = false
          @trigger 'inactive'
        @dx -= 0.05
