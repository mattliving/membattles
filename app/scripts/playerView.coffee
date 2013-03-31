define ["app", "marionette"], (App, Marionette) ->

  class PlayerView extends Marionette.ItemView

    className: "span9 media well"
        
    template: $("#playerTemplate")