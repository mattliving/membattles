define [
  "marionette",
  "vent",
  "views/inputView",
  "views/membattle",
  "collections/things"
],
(Marionette, vent, InputView, Membattle, Things) ->

  class GameLayout extends Marionette.Layout

    className: "span12"

    template: "#gameTemplate"

    ui:
      input: "#inputArea"

    regions:
      thisPlayer: "#thisPlayer"
      thatPlayer: "#thatPlayer"
      input:      "#inputArea"
      game:       "#game"

    # only the first argument is being sent for some awful reason.
    # This is the quickest (and ugliest) workaround...
    initialize: ({@socket, @thisPlayerController}) ->
      @thisPlayer.on "show", (view) =>
        view.on "ready", =>
          @thisPlayerReady = not @thisPlayerReady
          @trigger("ready")
          @socket.emit 'ready', {}
        view.on "things:fetched", (@thisPlayerThings) =>
          @thisPlayerController.things = @thisPlayerThings
          @socket.emit 'things', @thisPlayerThings.toJSON()
          @trigger("data:fetched")

      @socket.on "ready", =>
        @thatPlayerReady = not @thatPlayerReady
        @trigger("ready")

      @socket.on 'things', (things) =>
        @thatPlayerThings = new Things(things)
        @thatPlayerController.things = @thatPlayerThings
        @trigger("data:fetched")

      @on "ready", =>
        if @thisPlayerReady and @thatPlayerReady
          @thisPlayer.currentView.removeRegion("courses")
          @thatPlayer.currentView.removeRegion("courses")
          @thisPlayer.currentView.model.set("ready", true)
          @thatPlayer.currentView.model.set("ready", true)
          @thisPlayer.currentView.trigger("fetch:data")

      @on "data:fetched", =>
        if @thisPlayerThings and @thatPlayerThings
          @startGame()

      vent.on "game:ended", (username) =>
        @endGame(username)

    startGame: ->
      @input.show new InputView()
      # @ui.input.append("<h2>Game starting in 3 seconds!</h2>")
      # setTimeout (() =>
      #   @ui.input.children("h2").text("Game starting in 2 seconds!")
      # ), 1000
      # setTimeout (() =>
      #   @ui.input.children("h2").text("Game starting in 1 seconds!")
      # ), 2000
      # setTimeout (() =>
      #   @ui.input.children("h2").remove()
      membattle = new Membattle(@socket, @input.currentView, @thisPlayerController, @thatPlayerController, @thisStarts)
      @game.show(membattle)
      membattle.startAnimation()
      # ), 3000

    endGame: (username) ->
      @input.currentView.close()
      @game.currentView.close()
      @input.$el.append("<h1>#{username} Wins!</h1>")
