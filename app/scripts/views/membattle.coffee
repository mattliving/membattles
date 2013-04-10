define [
  "marionette",
  "vent",
  "items/item",
  "items/imageItem",
  "items/floor",
  "items/plant",
  "items/cannon",
  "views/textView"
],
(Marionette, vent, Item, ImageItem, Floor, Plant, Cannon, TextView) ->
  # this class is responsible for:
  # * connecting one player to the user input
  # * connecting the other player up to the server
  # * linking together the events of the two players
  # * starting animations and rendering the list of Elements
  class Membattle extends Marionette.View

    tagName: "canvas"

    attributes:
      height : "800px"

    ui:
      thisPlayer: "#thisPlayer"
      thatPlayer: "#thatPlayer"

    factory: {}
    items: []

    stopped: false

    initialize: (@socket, @input, @thisPlayerController, @thatPlayerController, @thisStarts) ->
      @$el.attr("width", $(".span12").css("width"))
      @ctx = @el.getContext("2d")
      @floor = new Floor(0, @el.height/2, 1, true)
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
        console.log 'emiting keypress event'
        @socket.emit 'keypress', input

      @socket.on 'keypress', (input) =>
        @input.trigger 'keypress', input

      @socket.on 'guess', (guess) =>
        @thatPlayerController.trigger 'guess', guess

      vent.on 'other:disconnect', =>
        @stopAnimation()
        @input.disable()
        @ctx.fillStyle = "rbga(1, 1, 1, 0.5)"
        @ctx.font = "30pt 'Comic Sans MS'"
        @ctx.fillRect(0, 0, @el.width, @el.height)
        @ctx.fillStyle = "white"
        @ctx.fillText("User disconnected :(", @el.width/2, @el.height/2)
        # setTimeout((=> @ctx.clearRect(0, 0, @el.height, @el.width)), 2000)

      # show the other person's answer under the input box
      @thatPlayerController.on 'next', =>
        if @thatPlayerController.textView.model?
          @input.ui.otheranswer.html("Their answer:" + @thatPlayerController.textView.model.get("text"))

      @thisPlayerController.on 'next', =>
        @input.ui.otheranswer.html('')

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

    setPlayer: ->
      if @currentPlayer is 1
        @$player2.removeClass("currentPlayer")
        @$player1.addClass("currentPlayer")
        @currentPlayer = 2
      else if @currentPlayer is 2
        @$player1.removeClass("currentPlayer")
        @$player2.addClass("currentPlayer")
        @currentPlayer = 1

    startAnimation: ->
      @ms = 0
      if @thisStarts
        @thisPlayerController.trigger("next")
      else
        @thatPlayerController.trigger("next")

      @update(Date.now())

    stopAnimation: -> @stopped = true

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
          for item, i in @items
            unless item.active
              @items.splice(i, 1)
          @ms -= 10
        requestAnimFrame (=>
          @update(time)
        ), @ctx
      else console.log 'stopped!'
