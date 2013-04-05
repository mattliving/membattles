define ["items/item"],
(Item) ->

  class TextView extends Item

    constructor: (@collection, @floor, startPosition, startForce = [0, 0]) ->

      @collection.map (model) =>
        model.set("position", startPosition)
        model.applyForce(startForce[0], startForce[1])
        model.set("floor", @floor)
        return model

      @on 'next', =>
        @model = @collection.getNext()
        if @model?
          @model.activate()
        else
          @active = false
          @trigger 'done'
      # temporary way to get the cannon to keep firing
      @on 'inactive', ->
        @expFrames = 0
        @trigger 'next'
        # @expFrames = 0
        # @active = false

      @trigger "next"
      @active = true

    draw: (ctx) ->
      if @model.get("active")
        ctx.font = "15pt 'Comic Sans MS'"
        ctx.fillStyle = "black"
        if @model.get("collided")
          @explode(ctx)
          @expFrames ?= 0
          @expFrames++
          if @expFrames > 50
            console.log "inactive"
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

    update: -> @model.update()
