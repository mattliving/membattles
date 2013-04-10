define [
  "marionette",
  "vent",
  "collections/things",
  "bootstrap.button"],
(Marionette, vent, Things) ->

  class PlayerView extends Marionette.Layout

    className: "media well"

    template: "#playerTemplate"

    events:
      "click .btn" : "toggleReady"

    modelEvents:
      "change" : "render"

    regions:
      courses: "#courses"

    initialize: ({@disabled}) ->
      @on "show", ->
        @$btn = @addReadyButton()

      @courses.on "show", (view) =>
        @listenTo view, "itemview:selected", (childView) =>
          @selectedCourse = childView

      @on 'fetch:data', @getCourseModel, @

    onDomRefresh: ->
      @$btn.button()

    onRender: ->
      if @model.get("currentPlayer")
        @$el.parent().addClass("currentPlayer")
      else 
        @$el.parent().removeClass("currentPlayer")

    addReadyButton: ->
      $btn = $("<button class='btn btn-block' type='button'><strong>Ready!</strong></button>") 
      @$el.children(".media-body").after($btn)
      return $btn

    toggleReady: (e) ->
      e.preventDefault()
      if @selectedCourse and not @disabled
        @$btn.button("toggle")
        @model.ready()
        if @model.get("ready")
          @trigger("ready")
          @$btn.remove()

    getCourseModel: ->
      @selectedCourse.model.url = @selectedCourse.model.urlRoot + @selectedCourse.model.get("id")
      @selectedCourse.model.parse = (response) ->
        response.course

      @selectedCourse.model.fetch(
        success: (model) =>
          @trigger("course:fetched", (model))
      ).done =>
        @things = new Things()
        @things.url += @selectedCourse.model.get("levels")[0].id
        @things.fetch(
          success: (collection) =>
            @trigger("things:fetched", collection)
          )
