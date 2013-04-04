define ["app", "Item", "models/text", "collections/texts"], (App, Item, TextModel, Texts) ->

  class TextView extends Item

    constructor: (@course_id, @floor, startPostition, startForce = [0, 0]) ->
      @collection = new Texts()
      @active = false

      $.getJSON "http://www.memrise.com/api/course/get/?course_id=#{@course_id}&levels_with_thing_ids=true", ({course: levels: 0: {thing_ids}}) =>
        @collection.unloaded = thing_ids.length
        for thing_id in thing_ids
          newText = new TextModel(
            id: thing_id
            position: startPostition
            floor: @floor
          )
          [fx, fy] = startForce
          newText.applyForce(fx, fy)
          newText.fetch success: (model) ->
            model.trigger 'loaded'
          @collection.addText(newText)
        return

      @collection.on "ready", @activate, @

      @collection.on 'next', =>
        @model = @collection.getNext()
        @trigger 'next'

    draw: (ctx) ->
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

    update: -> @model.update()

    activate: ->
      @active = true
      @collection.trigger "next"
