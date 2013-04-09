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
    initialize: ({@socket, @thisPlayerManager}) ->
      @thisPlayer.on "show", (view) =>
        view.on "ready", =>
          @thisPlayerReady = not @thisPlayerReady
          @trigger("ready")
          @socket.emit 'ready', {}
        view.on "things:fetched", (@thisPlayerThings) =>
          # window.things = @thisPlayerThings
          @thisPlayerManager.things = @thisPlayerThings
          @socket.emit 'things', @thisPlayerThings.toJSON()
          @trigger("data:fetched")

      @socket.on "ready", =>
        @thatPlayerReady = not @thatPlayerReady
        @trigger("ready")

      @socket.on 'things', (things) =>
        @thatPlayerThings = new Things(things)
        @thatPlayerManager.things = @thatPlayerThings
        @trigger("data:fetched")

      @on "ready", =>
        if @thisPlayerReady and @thatPlayerReady
          @thisPlayer.currentView.removeRegion("courses")
          @thatPlayer.currentView.removeRegion("courses")
          @thisPlayer.currentView.ui.btn.remove()
          @thatPlayer.currentView.ui.btn.remove()
          @thisPlayer.currentView.trigger("fetch:data")

      @on "data:fetched", =>
        if @thisPlayerThings and @thatPlayerThings
          @startGame()

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
      membattle = new Membattle(@socket, @thisPlayerManager, @thatPlayerManager, @thisStarts)
      @game.show(membattle)
      membattle.startAnimation()
      # ), 3000
