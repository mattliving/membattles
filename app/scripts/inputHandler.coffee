define ["app"], (App) ->

  class InputHandler
    # Backbone.Events is still a regular object,
    # so this has to be done to extend it properly
    _.extend(InputHandler::, Backbone.Events)

    constructor: ->
      @$input = $("#guess")
      @$input.change (e) =>
        guess = $(e.currentTarget).val()
        @trigger("change", guess)
