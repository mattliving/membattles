define ["items/item"],
(Item) ->

  class TextView extends Item

    constructor: (@collection, @floor, startPosition, startForce = [0, 0]) ->
      super()

      @collection.map (model) =>
        model.set("position", startPosition)
        model.applyForce(startForce[0], startForce[1])
        model.set("floor", @floor)
        return model

      @on 'next', =>
        @expFrames = 0
        @model = @collection.getNext()
        if @model?
          @model.activate()
          @active = true
        else
          @active = false
          @trigger 'done'

      @active = false

    draw: (ctx) ->
      if @model.get("active")
        ctx.font = "15pt 'Comic Sans MS'"
        ctx.fillStyle = "#222"
        if @model.get("collided")
          @explode(ctx)
          @expFrames ?= 0
          @expFrames++
          if @expFrames > 50
            @model.deactivate()
            @trigger("inactive", @model.get("success"))
        else
          [x, y] = @model.get("position")
          ctx.fillText(@model.get("translation"), x, y)

    explode: (ctx) ->
      ctx.beginPath()
      [x, y] = @model.get("position")
      ctx.arc(x, y, 40, 2*Math.PI, false)
      ctx.fillStyle = if @model.get("success") then "green" else "red"
      ctx.fill()
      ctx.fillStyle = "black"

    update: -> @model.update()
