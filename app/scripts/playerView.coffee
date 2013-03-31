define ["app", "marionette"], (App, Marionette) ->

  class PlayerView extends Marionette.Layout

    className: "media well"
        
    template: "#playerTemplate"

    regions: 
      courses: "#courses"