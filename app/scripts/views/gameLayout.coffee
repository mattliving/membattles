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

    initialize: ->
      @numberOfPlayers = 2

      @thisPlayer.on "show", (view) =>
        @listenTo view, "ready", () =>
          @thisPlayerReady = if @thisPlayerReady then false else true
          @trigger("ready")
        vent.on "things:fetched", (things) =>
          @thisPlayerThings = things

      @thatPlayer.on "show", (view) =>
        @listenTo view, "ready", () =>
          @thatPlayerReady = if @thatPlayerReady then false else true
          @trigger("ready")
        vent.on "things:fetched", (things) =>
          @thatPlayerThings = things

      @on "ready", () =>
        if @thisPlayerReady and @thatPlayerReady
          @thisPlayer.currentView.removeRegion("courses")
          @thatPlayer.currentView.removeRegion("courses")
          @thisPlayer.currentView.ui.btn.remove()
          @thatPlayer.currentView.ui.btn.remove()
          vent.trigger("game:starting")

      i = 0
      vent.on "things:fetched", =>
        i++
        if i is @numberOfPlayers
          @startGame()

    startGame: () ->
      @input.show(new InputView())
      # @ui.input.append("<h2>Game starting in 3 seconds!</h2>")
      # setTimeout (() =>
      #   @ui.input.children("h2").text("Game starting in 2 seconds!")
      # ), 1000
      # setTimeout (() =>
      #   @ui.input.children("h2").text("Game starting in 1 seconds!")
      # ), 2000
      # setTimeout (() =>
      #   @ui.input.children("h2").remove()
      membattle = new Membattle(@thisPlayerThings, @thatPlayerThings)
      @game.show(membattle)
      membattle.startAnimation()
      # ), 3000
