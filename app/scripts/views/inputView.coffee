define ["marionette", "vent"], 
(Marionette, vent) ->
  
  class InputView extends Marionette.ItemView
    
    className: "typing-wrapper"

    template: "#inputTemplate"
    
    events:
      click: "toggleSelected"
