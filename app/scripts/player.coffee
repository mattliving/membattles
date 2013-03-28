define ["app"], (App) ->

  class Player extends Backbone.Model

    url: () ->
      "http://www.memrise.com/api/user/get/?user_username=" + @get("user").username

    defaults:
      user: {}
      points: 0
      lives: 3
      position: "left"
