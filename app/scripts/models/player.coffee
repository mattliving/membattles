define ["app"], (App) ->

  class Player extends Backbone.Model

    url: ->
      "http://www.memrise.com/api/user/get/?user_username=" + @get("username")

    parse: (response) ->
      response.user

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
