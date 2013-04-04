define ["items/item"],
(Item) ->

  class TextView extends Item

    constructor: (@collection, @floor, startPosition, startForce = [0, 0]) ->

      @collection.map (model) =>
        model.set("position", startPosition)
        model.set("force", startForce)
        model.set("floor", @floor)

      @collection.on 'next', =>
        @model = @collection.getNext()
        @trigger 'next'

      @on "inactive", -> @expFrames = 0

      @activate()

    draw: (ctx) ->
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

    update: -> @model.update()

    activate: ->
      @collection.trigger "next"
      @active = true
