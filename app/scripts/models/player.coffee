define ["app"], (App) ->

  class Player extends Backbone.Model

    initialize: ->
      @set("currentText", 0)

    url: ->
      "http://www.memrise.com/api/user/get/?user_username=" + @get("username")

    parse: (response) -> response.user

    defaults:
      username: "",
      url: "",
      photo_small: "",
      is_staff: false,
      current_follows: false,
      is_authenticated: false,
      photo: "",
      photo_large: "",
      id: null,
      follows_current: false
      points: 0
      lives: 3
      position: "left"
      ready: false

    addCannon: (cannon) ->
      @set("cannon", cannon)

    addText: (text) ->
      cannon = @get("cannon")
      text.x = cannon.x*cannon.offset+60
      text.y = cannon.y
      if cannon.mirrored then text.x = canvas.width - text.x
      text.on "inactive", =>
        @trigger "inactive"

      # @on "nextText", ->
      #   if @currentText < @text.length
      #     console.log "activating next" + (+@mirrored + 1)
      #     @text[@currentText++].activate()

    ready: ->
      @set("ready", !@get("ready"))
