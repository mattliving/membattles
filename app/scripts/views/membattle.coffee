define [
  "marionette",
  "vent",
  "items/item",
  "items/imageItem",
  "items/floor",
  "items/plant",
  "items/cannon",
  "items/textItem"
],
(Marionette, vent, Item, ImageItem, Floor, Plant, Cannon, TextItem) ->

  class Membattle extends Marionette.View

    tagName: "canvas"

    attributes:
      height : "800px"

    ui:
      thisPlayer: "#thisPlayer"
      thatPlayer: "#thatPlayer"

    stopped: true

    initialize: (@socket, @input, @thisPlayerController, @thatPlayerController, @thisStarts) ->
      @$el.attr("width", $(".span12").css("width"))
      @ctx = @el.getContext("2d")
      @floor = new Floor
        pos:
          x: @el.width/2
          y: @el.height/2
        scale: 1
        active: true

      @thisPlayerController.initialize(@floor)
      @thatPlayerController.initialize(@floor)

      @input.listenTo @thatPlayerController, 'next', ->
        @ui.input.prop('disabled', true)
        @ui.input.css('color', 'grey')
      @input.listenTo @thisPlayerController, 'next', ->
        @ui.input.prop('disabled', false)
        @ui.input.removeAttr('style')

      @input.on 'guess', (guess) =>
        @thisPlayerController.trigger 'guess', guess
        @socket.emit 'guess', guess

      @input.on 'keyup', (input) =>
        @socket.emit 'keypress', input

      @socket.on 'keypress', (input) =>
        @input.trigger 'keypress', input

      @socket.on 'guess', (guess) =>
        @thatPlayerController.trigger 'guess', guess

      @thisPlayerController.on 'exploded', (text, success) =>
        unless success or @stopped
          @input.ui.thisanswer.html("Correct answer: #{text}")

      @thatPlayerController.on 'endTurn', =>
        unless @stopped
          @input.ui.thisanswer.html('')

      vent.on 'other:disconnect', =>
        @stopAnimation()
        @ctx.fillStyle = "black"
        @ctx.globalAlpha = 0.5
        @ctx.font = "28pt 'Merriweather Sans'"
        @ctx.fillRect(0, 0, @el.width, @el.height)
        @ctx.globalAlpha = 1
        @ctx.fillStyle = "white"
        @ctx.fillText("User disconnected :(", @el.width/2, @el.height/2)

      vent.on 'game:ending', (username) =>
        @stopAnimation()
        if username is @thisPlayerController.playerView.model.get('username')
          vent.trigger 'game:ended', "You Lose!"
        else
          vent.trigger 'game:ended', "You Win!"

      # Show the other person's answer under the input box
      # @thatPlayerController.on 'next', =>
      #   if @thatPlayerController.textView.model?
      #     @input.ui.otheranswer.text("Their answer:" + @thatPlayerController.textView.model.get("text"))

      @thisPlayerController.on 'next', =>
        @input.ui.otheranswer.text('')

      @thisPlayerController.on 'endTurn', =>
        @input.disable()
        @thatPlayerController.trigger('next')

      @thatPlayerController.on 'endTurn', =>
        @input.enable()
        @thisPlayerController.trigger('next')

    initPlants: (x, y, n, type) ->
      for i in [1..n]
        if type is "medium"
          plant   = new Plant(x, y, "/images/medium_plant.png", 1.1, 0.3, true)
          plant.x = i+@largePlants
          plant.y += 24
        else
          plant   = new Plant(x, y, "/images/large_plant.png", 1.1, 0.3, true)
          plant.x = i
        @items.push plant

    startAnimation: ->
      @ms = 0
      if @thisStarts
        @thisPlayerController.trigger("next")
      else
        @thatPlayerController.trigger("next")

      @stopped = false
      @update(Date.now())

    stopAnimation: ->
      @stopped = true
      @input.disable()
      @input.off('keyup')
      @input.off('guess')

    update: (lastTime) ->
      unless @stopped
        time = Date.now()
        dx = time - lastTime
        @ms += dx
        while @ms > 10
          @ctx.clearRect(0, 0, @el.width, @el.height)
          for item in Item.items
            if item? and item.active
              item.draw(@ctx)
              item.update()
          @ms -= 10
        requestAnimFrame (=>
          @update(time)
        ), @ctx
