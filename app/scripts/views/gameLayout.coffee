define [
  "marionette",
  "vent",
  "views/inputView",
  "views/membattle"
],
(Marionette, vent, InputView, Membattle) ->

  class GameLayout extends Marionette.Layout

    className: "span12"

    template: "#gameTemplate"

    ui:
      input: "#inputArea"

    regions:
      thisPlayer: "#thisPlayer"
      thatPlayer: "#thatPlayer"
      input:   "#inputArea"
      game:    "#game"

    # only the first argument is being sent for some awful reason.
    # This is the quickest (and ugliest) workaround...
    initialize: ({@thisPlayerManager, @thatPlayerManager}) ->
      @thisPlayer.on "show", (view) =>
        view.on "ready", =>
          # because !undefined in js is true
          @thisPlayerReady = not @thisPlayerReady
          @trigger("ready")
        view.on "things:fetched", (@thisPlayerThings) => @trigger("data:ready")

      @thatPlayer.on "show", (view) =>
        view.on "ready", =>
          @thatPlayerReady = not @thatPlayerReady
          @trigger("ready")
        view.on "things:fetched", (@thatPlayerThings) => @trigger("data:ready")

      @on "ready", =>
        if @thisPlayerReady and @thatPlayerReady
          @thisPlayer.currentView.removeRegion("courses")
          @thatPlayer.currentView.removeRegion("courses")
          @thisPlayer.currentView.ui.btn.remove()
          @thatPlayer.currentView.ui.btn.remove()
          vent.trigger("game:starting")

      @on "data:ready", =>
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
      membattle = new Membattle(@thisPlayerManager, @thatPlayerManager)
      @game.show(membattle)
      membattle.startAnimation()
      # ), 3000
