define ["marionette", "vent"],
(Marionette, vent) ->

  class InputView extends Marionette.ItemView

    className: "typing-wrapper"

    template: "#inputTemplate"

    ui:
      input: "#guess"

    events:
      click: "toggleSelected"
      change: "inputChanged"

    inputChanged: (e) ->
      guess = @ui.input.val()
      @ui.input.val("")
      console.log "guessed " + guess
      vent.trigger("input:guess", guess)
