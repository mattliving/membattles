define [
  "marionette",
  "helpers/vent",
  "helpers/timer",
  "items/item",
  "items/imageItem",
  "items/floor",
  "items/textItem",
  "items/letter"
],
(Marionette, vent, Timer, Item, ImageItem, Floor, TextItem, Letter) ->

  class Membattle extends Marionette.View

    tagName: "canvas"

    ui:
      thisPlayer: "#thisPlayer"
      thatPlayer: "#thatPlayer"

    stopped: true

    aspectRatio: 16 / 9

    initialize: (@socket, @input, @thisPlayerController, @thatPlayerController, @thisStarts) ->
      @el.width  = $(".span12").width()
      @el.height = window.innerHeight - $(".player-container").height() - 15
      @ctx       = @el.getContext("2d")
      Item.setContext @ctx
      @timer = new Timer()
      @floor = new Floor
        pos:
          x: @el.width/2
          y: @el.height*4/5
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
        @socket.emit 'keypress', input

      @socket.on 'keypress', (input) =>
        @input.trigger 'keypress', input

      # Show the other person's answer under the input box
      @thatPlayerController.on 'next', =>
        @input.ui.otheranswer.text("Their answer: " + @thatPlayerController.getData().text)

      @thisPlayerController.on 'next', =>
        @input.ui.otheranswer.text("")

      # show our correct answer under the text box, and disable and enable
      # the input box, start the other player when one stops
      @thisPlayerController.on 'endTurn', (text, success) =>
        unless success
          @input.ui.thisanswer.text("Correct answer: #{text}")
        unless @stopped
          @input.disable()
          @thatPlayerController.trigger('next')

      @thatPlayerController.on 'endTurn', =>
        unless @stopped
          @input.ui.thisanswer.text('')
          @input.enable()
          @thisPlayerController.trigger('next')

      # global events that membattle has to deal with
      vent.on 'other:disconnect', =>
        @stop()
        @ctx.fillStyle = "black"
        @ctx.globalAlpha = 0.5
        @ctx.font = "28pt 'Merriweather Sans'"
        width = @ctx.measureText("User disconnected :(")
        @ctx.fillRect(0, 0, @el.width, @el.height)
        @ctx.globalAlpha = 1
        @ctx.fillStyle = "white"
        @ctx.fillText("User disconnected :(", @el.width/2-width, @el.height/2-28)

      vent.on 'game:ending', =>
        @stop()
        @checkWinner()

      # vent.on 'game:playAgain', =>
      #   @socket.emit 'invalidate'
      #   @socket.emit 'register', user: @thisPlayerController.playerModel.get('username')

    checkWinner: ->
      thisModel = @thisPlayerController.playerModel
      thatModel = @thatPlayerController.playerModel
      if thisModel.get('lives') <= 0 or thisModel.get('points') < thatModel.get('points')
        vent.trigger 'game:ended', thatModel.get('username') + ' Wins!'
      else if thatModel.get('lives') <= 0 or thisModel.get('points') > thatModel.get('points')
        vent.trigger 'game:ended', thisModel.get('username') + ' Wins!'
      else vent.trigger 'game:ended', "It's a Draw!"

    start: ->
      if @thisStarts
        @thisPlayerController.trigger("next")
        @input.enable()
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
