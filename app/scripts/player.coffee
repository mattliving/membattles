define ["app"], (App) ->

  class Player extends Backbone.Model

    url: "http://www.memrise.com/api/user/get/?user_username="

    defaults:
      id: null
      username: ""
      url: ""
      photo_small: ""
      is_staff: false
      is_authenticated: false
      photo: ""
      photo_large: ""
      points: 0
      lives: 3

    initialize: (@username) ->
      @url += @username
