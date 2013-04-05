define [
  "marionette",
  "vent",
  "views/inputView",
  "views/membattle"],
(Marionette, vent, InputView, Membattle) ->

  class GameLayout extends Marionette.Layout

    className: "span12"

    template: "#gameTemplate"

    ui:
      input: "#inputArea"

    regions:
      player1: "#player1"
      player2: "#player2"
      input:   "#inputArea"
      game:    "#game"

    initialize: ->
      @numberOfPlayers = 2

      @player1.on "show", (view) =>
        @listenTo view, "ready", () =>
          @player1Ready = if @player1Ready then false else true
          @trigger("ready")
        vent.on "things:fetched", (things) =>
          @player1Things = things

      @player2.on "show", (view) =>
        @listenTo view, "ready", () =>
          @player2Ready = if @player2Ready then false else true
          @trigger("ready")
        vent.on "things:fetched", (things) =>
          @player2Things = things

      @on "ready", () =>
        if @player1Ready and @player2Ready
          @player1.currentView.removeRegion("courses")
          @player2.currentView.removeRegion("courses")
          @player1.currentView.ui.btn.remove()
          @player2.currentView.ui.btn.remove()
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
      membattle = new Membattle(@player1Things, @player2Things)
      @game.show(membattle)
      membattle.startAnimation()
      # ), 3000
