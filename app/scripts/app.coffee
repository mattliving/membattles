define [
  "marionette",
  "helpers/vent",
  "views/gameLayout",
  "views/loadingView",
  "views/landingView",
  "playerController",
  "socket.io"
],
(Marionette, vent, GameLayout, LoadingView, LandingView, PlayerController, io) ->

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
  landingView = new LandingView()

  app.addInitializer ->
    app.main.show(loadingView)
    $.getJSON "http://www.memrise.com/api/hello/", (data) ->
      app.main.show(landingView)
      landingView.loggedIn(data.user?)

  socket = io.connect("http://wordwar.memrise.com")

  socket.on 'error', ({msg}) -> console.log "ERROR #{msg}"

  landingView.on 'start', (username, userdata) =>
    thisPlayer = new PlayerController username: username, local: true
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
