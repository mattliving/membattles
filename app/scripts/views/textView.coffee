define ["app", "Item", "models/text", "collections/texts"], (App, Item, Text, Texts) ->

  class TextView extends Item
    
    constructor: (@collection, @floor, forces) ->
      @collection = new Collection()
      @collection.on 'next', =>
        @model = @collection.getNext()
        @trigger 'next'
      
    draw: (ctx) ->
      @model.update()
      ctx.font = "15pt 'Comic Sans MS'"
      if @model.get("collided")
        @explode(ctx)
        @expFrames ?= 0
        @expFrames++
        if @expFrames > 50
          @model.trigger("inactive")
          @trigger("inactive")
      else
        [x, y] = @model.get("position")
        ctx.fillText(@model.get("text"), x, y)
        
    explode: (ctx) ->
      ctx.beginPath()
      [x, y] = @model.get("position")
      ctx.arc(x, y, 40, 2*Math.PI, false)
      ctx.fillStyle = if @model.get("success") then "green" else "red"
      ctx.fill()
      ctx.fillStyle = "black"
