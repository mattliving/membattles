define ["marionette"], 
(Marionette) ->

  class GameLayout extends Marionette.Layout
        
    className: "span12"

    template: "#gameTemplate"

    regions: 
      player1: "#player1"
      player2: "#player2"
      game:    "#game"

    initialize: ->
