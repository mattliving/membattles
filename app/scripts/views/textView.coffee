define ["items/item"], (Item) ->

  class TextView extends Item

    constructor: (options) ->
      super(options)
      {@collection, @floor, @startPosition, @startForce} = options

      @collection.map (model) =>
        model.set("position", @startPosition)
        model.applyForce(@startForce[0], @startForce[1])
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

      @listenTo @collection, 'change:collided', (model) ->
        @trigger("exploded", model.get('text'), model.get('success'))

    draw: (ctx) ->
      if @model.get("active")
        ctx.font = "24pt 'Merriweather Sans'"
        ctx.fillStyle = "#222"
        if @model.get("collided")
          @explode(ctx)
          @expFrames++
          if @expFrames > 50
            @model.deactivate()
            @trigger "inactive", @model.get("success")
        else
          [x, y] = @model.get("position")
          ctx.fillText(@model.get("translation"), x, y)

    explode: (ctx) ->
      [x, y] = @model.get("position")
      lastFill = ctx.fillStyle
      ctx.beginPath()
      ctx.arc(x, y, 40, 2*Math.PI, false)
      ctx.fillStyle = if @model.get("success") then "green" else "red"
      ctx.fill()
      ctx.fillStyle = lastFill

    update: -> @model.update()
