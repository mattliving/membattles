define ["marionette", "vent"],
(Marionette, vent) ->

  class InputView extends Marionette.ItemView

    className: "typing-wrapper"

    template: "#inputTemplate"

    ui:
      input: "#guess"
      otheranswer: "#otheranswer"

    events:
      click: "toggleSelected"
      change: "inputChanged"
      keyup: "keyPressed"
      keydown: "testKey"

    initialize: ->
      @on 'keypress', (input) =>
        console.log 'vent keypress'
        if @ui.input.prop("disabled")
          @ui.input.val(input)

    inputChanged: (e) ->
      # we no longer empty the box here as this will be done by disable
      e.preventDefault()
      guess = @ui.input.val()
      @trigger("guess", guess)

    keyPressed: (e) ->
      @trigger("keyup", @ui.input.val())

    # stop the backspace key from ruining everything
    testKey: (e) ->
      if e.which is 8
        e.preventDefault()
        e.stopPropagation()

    enable: ->
      @ui.input.prop("disabled", false)
      @ui.input.val('')
      @ui.input.focus()

    disable: ->
      @ui.input.prop("disabled", true)
      @ui.input.val('')
