define [
  "marionette",
  "helpers/vent",
  "views/gameLayout",
  "views/loadingView",
  "views/loginView",
  "playerController",
  "socket.io"
],
(Marionette, vent, GameLayout, LoadingView, LoginView, PlayerController, io) ->

  window.requestAnimFrame = do ((callback) ->
    window.requestAnimationFrame       ||
    window.webkitRequestAnimationFrame ||
    window.mozRequestAnimationFrame    ||
    window.oRequestAnimationFrame      ||
    window.msRequestAnimationFrame     ||
    (callback) -> window.setTimeout(callback, 1000 / 60)
  )

  app = new Marionette.Application()

  app.addRegions
    main: "#main"
    game: "#game"

  loadingView = new LoadingView()

  loginView = new LoginView()

  app.addInitializer ->
    app.main.show(loadingView)
    $.getJSON "http://www.memrise.com/api/hello/", (data) ->
      console.log data
      if data.user?
        loadingView.trigger('loaded', data.user.username, data.user)
      else
        alert("Log in to memrise")

  socket = io.connect("http://wordwar.memrise.com")

  socket.on 'error', ({msg}) -> console.log "ERROR #{msg}"

  loadingView.on 'loaded', (username, userdata) =>
    thisPlayer = new PlayerController username, true
    gameLayout = new GameLayout socket: socket, thisPlayerController: thisPlayer

    app.main.show(gameLayout)

    thisPlayer.on 'model:fetched', ->
      gameLayout.thisPlayer.show(@playerLayout)
      @trigger("view:rendered")

    socket.emit 'register', user: username

    socket.on 'registered', ->
      socket.emit 'getid', {}

      socket.on 'disconnect', -> vent.trigger 'other:disconnect'

      socket.on 'otherid', ({id, user, first}) ->

        thatPlayer = new PlayerController user, false
        gameLayout.thatPlayerController = thatPlayer
        gameLayout.thisStarts = not first

        thatPlayer.on 'model:fetched', ->
          gameLayout.thatPlayer.show(@playerLayout)
          @trigger("view:rendered")

        vent.on "game:starting", (view) ->
          app.game.show(view)

  return app
