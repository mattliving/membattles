define ["marionette", "vent"],
(Marionette, vent) ->

  class InputView extends Marionette.ItemView

    className: "typing-wrapper"

    template: "#inputTemplate"

    ui:
      input: "#guess"
      otheranswer: "#otheranswer"
      thisanswer: "#thisanswer"

    events:
      click: "toggleSelected"
      change: "inputChanged"
      keyup: "keyPressed"
      keydown: "testKey"

    initialize: ->
      @on 'keypress', (input) =>
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
      if e.which is 8 and @ui.input.prop("disabled")
        e.preventDefault()
        e.stopPropagation()

      unless @ui.input.prop("disabled")
        console.log String.fromCharCode(e.charCode)

    enable: ->
      # simple test if it's an input box
      if @ui.input.prop
        @ui.input.prop("disabled", false)
        @ui.input.val('')
        @ui.input.focus()

    disable: ->
      if @ui.input.prop
        @ui.input.prop("disabled", true)
        @ui.input.val('')
