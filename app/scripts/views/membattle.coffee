define [
  "marionette",
  "helpers/vent",
  "helpers/timer",
  "items/item",
  "items/imageItem",
  "items/floor",
  "items/plant",
  "items/cannon",
  "items/textItem"
],
(Marionette, vent, Timer, Item, ImageItem, Floor, Plant, Cannon, TextItem) ->

  class Membattle extends Marionette.View

    tagName: "canvas"

    # attributes:
    #   width: "960px"
    #   height : "640px"

    ui:
      thisPlayer: "#thisPlayer"
      thatPlayer: "#thatPlayer"

    stopped: true

    aspectRatio: 16 / 9

    initialize: (@socket, @input, @thisPlayerController, @thatPlayerController, @thisStarts) ->
      @el.setAttribute "width", $(".span12").width()
      @el.setAttribute "height", @el.getAttribute("width")/@aspectRatio
      @ctx = @el.getContext("2d")
      @timer = new Timer()
      @floor = new Floor
        pos:
          x: @el.width/2
          y: @el.height/2
        scale: 1
        active: true

      @thisPlayerController.initialize(@floor)
      @thatPlayerController.initialize(@floor)

      # make the input box fade out & be disabled as necessary
      @input.listenTo @thatPlayerController, 'next', ->
        @ui.input.prop('disabled', true)
        @ui.input.css('color', 'grey')
      @input.listenTo @thisPlayerController, 'next', ->
        @ui.input.prop('disabled', false)
        @ui.input.removeAttr('style')

      # send and listen to guesses, checking them against the correct player
      @input.on 'guess', (guess) =>
        @thisPlayerController.trigger 'guess', guess
        @socket.emit 'guess', guess

      @socket.on 'guess', (guess) =>
        @thatPlayerController.trigger 'guess', guess

      # send and listen to all keypress events, to show the other person typing
      @input.on 'keyup', (input) =>
        @socket.emit 'keypress', input
      @socket.on 'keypress', (input) =>
        @input.trigger 'keypress', input

      @thisPlayerController.on 'exploded', (text, success) =>
        unless success or @stopped
          @input.ui.thisanswer.html("Correct answer: #{text}")

      @thatPlayerController.on 'endTurn', =>
        unless @stopped
          @input.ui.thisanswer.html('')

      vent.on 'other:disconnect', =>
        @stop()
        @ctx.fillStyle = "black"
        @ctx.globalAlpha = 0.5
        @ctx.font = "28pt 'Merriweather Sans'"
        @ctx.fillRect(0, 0, @el.width, @el.height)
        @ctx.globalAlpha = 1
        @ctx.fillStyle = "white"
        @ctx.fillText("User disconnected :(", @el.width/2, @el.height/2)

      vent.on 'game:ending', (username) =>
        @stop()
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

    spawnEntity = (typename) ->
      entity = new (factory[typename])()
      @entities.push entity
      return entity

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

    start: ->
      if @thisStarts
        @thisPlayerController.trigger("next")
      else
        @thatPlayerController.trigger("next")

      @stopped = false
      @lastUpdateTimestamp = Date.now()
      do gameLoop = =>
        unless @stopped
          @loop()
          requestAnimFrame gameLoop, @ctx.canvas

    stop: ->
      @stopped = true
      @input.disable()
      @input.off('keyup')
      @input.off('guess')

    # main game loop
    loop: ->
      @ctx.clearRect(0, 0, @el.width, @el.height)
      Item.update(@timer.tick())
      Item.draw(@ctx)
