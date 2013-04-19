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

    modelEvents:
      "change" : "render"

    initialize: ({@disabled})->
      @on "show", @addButton, @
      @on 'fetch:data', @getCourseModel, @

    onDomRefresh: ->
      @$btn?.button()

    onBeforeRender: ->
      if @model.get("currentPlayer")
        @$el.parent().parent().addClass("currentPlayer")
      else
        @$el.parent().parent().removeClass("currentPlayer")

    addButton: ->
      if @disabled
        buttonText = "Waiting for another user..."
      else
        buttonText = "Ready!"
      @$btn = $("<button class='btn btn-block' type='button'><strong>#{buttonText}</strong></button>")
      if @disabled
        @$btn.addClass("disabled")

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
      @selectedCourse.parse = ({course}) -> course

      @selectedCourse.fetch(
        success: (model) =>
          @trigger("course:fetched", (model))
      ).done =>
        @things = new Things()
        @things.url += @selectedCourse.get("id")
        @things.fetch(
          success: (collection) =>
            # if there's less than 10 waterable items, get the first level of the course
            if collection.length < 10
              @things.url = "http://www.memrise.com/api/level/get/?with_content=true&level_id="+@selectedCourse.get("levels")[0].id
              @things.fetch reset: true, success: (collection) => @trigger("things:fetched", collection)
            else
              @trigger("things:fetched", collection)
          )
