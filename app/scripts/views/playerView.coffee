define [
  "marionette",
  "helpers/vent",
  "collections/things",
  "bootstrap.button"],
(Marionette, vent, Things) ->

  class PlayerView extends Marionette.ItemView

    className: "media"

    template: "#playerTemplate"

    events:
      "click .btn" : "toggleReady"

    # modelEvents:
    #   "change" : "render"

    initialize: ({@disabled})->
      @on "show", ->
        unless @disabled
          @addReadyButton()

      @on 'fetch:data', @getCourseModel, @

    onDomRefresh: ->
      @$btn?.button()

    onBeforeRender: ->
      if @model.get("currentPlayer")
        @$el.parent().parent().addClass("currentPlayer")
      else
        @$el.parent().parent().removeClass("currentPlayer")

    addReadyButton: ->
      @$btn = $("<button class='btn btn-block' type='button'><strong>Ready!</strong></button>")
      @$el.children(".media-body").after(@$btn)

    toggleReady: (e) ->
      e.preventDefault()
      if @selectedCourse and not @disabled
        @$btn.button("toggle")
        @model.set
          "ready": true
          "silent": true
        if @model.get("ready")
          @trigger("ready")

    getCourseModel: ->
      @selectedCourse.url = @selectedCourse.urlRoot + @selectedCourse.get("id")
      @selectedCourse.parse = (response) ->
        response.course

      @selectedCourse.fetch(
        success: (model) =>
          @trigger("course:fetched", (model))
      ).done =>
        @things = new Things()
        @things.url += @selectedCourse.get("levels")[0].id
        @things.fetch(
          success: (collection) =>
            @trigger("things:fetched", collection)
          )
