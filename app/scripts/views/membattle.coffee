define [
  "marionette",
  "helpers/vent",
  "helpers/timer",
  "items/item",
  "items/imageItem",
  "items/floor",
  "items/plant",
  "items/cannon",
  "items/textItem",
  "items/letter"
],
(Marionette, vent, Timer, Item, ImageItem, Floor, Plant, Cannon, TextItem, Letter) ->

  class Membattle extends Marionette.View

    tagName: "canvas"

    ui:
      thisPlayer: "#thisPlayer"
      thatPlayer: "#thatPlayer"

    stopped: true

    aspectRatio: 16 / 9

    initialize: (@socket, @input, @thisPlayerController, @thatPlayerController, @thisStarts) ->
      @el.width  = $(".span12").width()
      @el.height = @el.width/@aspectRatio
      @ctx       = @el.getContext("2d")
      Item.setContext @ctx
      @timer = new Timer()
      @floor = new Floor
        pos:
          x: @el.width/2
          y: @el.height/2
        scaleX: @el.width
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

      # trigger/listen to guesses, checking them against the correct player
      @input.on 'guess', (guess) =>
        @thisPlayerController.trigger 'guess', guess
        @socket.emit 'guess', guess

      @socket.on 'guess', (guess) =>
        @thatPlayerController.trigger 'guess', guess

      # send and listen to all keypress events, to show the other person typing
      @input.on 'keyup', (input, key) =>
        # find a way that this can support unicode symbols
        if key.match /\w+/
          @thisPlayerController.fireLetter(key, input, @thatPlayerController.spawnPos)
        @socket.emit 'keypress', input

      @socket.on 'keypress', (input) =>
        @input.trigger 'keypress', input

      # Show the other person's answer under the input box
      @thatPlayerController.on 'next', =>
        @input.ui.otheranswer.text("Their answer:" + @thatPlayerController.getData().text)

      @thisPlayerController.on 'next', =>
        @input.ui.otheranswer.text("")

      # show our correct answer under the text box
      @thisPlayerController.on 'exploded', (text, success) =>
        unless success or @stopped
          @input.ui.thisanswer.html("Correct answer: #{text}")

      @thatPlayerController.on 'endTurn', =>
        unless @stopped
          @input.ui.thisanswer.html('')

      # disable and enable the input box, start the other player when one stops
      @thisPlayerController.on 'endTurn', =>
        @input.disable()
        @thatPlayerController.trigger('next')

      @thatPlayerController.on 'endTurn', =>
        @input.enable()
        @thisPlayerController.trigger('next')

      # global events that membattle has to deal with
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
      @loop()

    stop: ->
      @stopped = true
      @input.disable()
      @input.off('keyup')
      @input.off('guess')

    # main game loop
    loop: ->
      unless @stopped
        @ctx.clearRect(0, 0, @el.width, @el.height)
        Item.update(@timer.tick())
        Item.draw(@ctx)
        requestAnimFrame @loop.bind(@), @ctx.canvas
