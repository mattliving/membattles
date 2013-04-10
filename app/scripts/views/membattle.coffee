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
  class Membattle extends Marionette.View

    tagName: "canvas"

    attributes:
      height : "800px"

    ui:
      thisPlayer: "#thisPlayer"
      thatPlayer: "#thatPlayer"

    items: []

    # This class is responsible for:
    #   Connecting one player to the user input
    #   Connecting the other player up to the server
    #   Linking together the events of the two players
    #   Starting and rendering animations
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
        @socket.emit 'keypress', input

      @socket.on 'keypress', (input) =>
        @input.trigger 'keypress', input

      @socket.on 'guess', (guess) =>
        @thatPlayerController.trigger 'guess', guess

      # Show the other person's answer under the input box
      @thatPlayerController.on 'next', =>
        @input.ui.otheranswer.text("Their answer:" + @thatPlayerController.textView.model.get("text"))

      @thisPlayerController.on 'next', =>
        @input.ui.otheranswer.text('')

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

      @thisPlayerController.on 'endTurn', =>
        @input.disable()
        @thatPlayerController.trigger('next')
      @thatPlayerController.on 'endTurn', =>
        @input.enable()
        @thisPlayerController.trigger('next')

      @update(Date.now())

    update: (lastTime) ->
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
