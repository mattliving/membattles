define [
  "marionette",
  "vent",
  "views/gameLayout",
  "views/loginView",
  "playerController",
  "socket.io"
],
(Marionette, vent, GameLayout, LoginView, PlayerController, io) ->

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

  loginView = new LoginView()

  app.addInitializer ->
    app.main.show(loginView)

  socket = io.connect(window.location.origin)

  socket.on 'error', ({msg}) -> console.log "ERROR #{msg}"

  window.socket = socket

  loginView.on 'submit', (username) =>
    thisPlayer = new PlayerController username, true
    gameLayout = new GameLayout socket: socket, thisPlayerController: thisPlayer

    app.main.show(gameLayout)

    thisPlayer.on 'model:fetched', ->
      gameLayout.thisPlayer.show(@playerView)
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
          gameLayout.thatPlayer.show(@playerView)
          @trigger("view:rendered")

  return app
