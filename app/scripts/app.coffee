define [
  "marionette",
  "helpers/vent",
  "views/gameLayout",
  "views/loadingView",
  "views/landingView",
  "views/loginView",
  "playerController",
  "socket.io"
],
(Marionette, vent, GameLayout, LoadingView, LandingView, LoginView, PlayerController, io) ->

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

  landingView = new LandingView()
  loginView = new LoginView()

  app.addInitializer ->
    app.main.show(landingView)
    $.getJSON "http://www.memrise.com/api/hello/", (data) ->
      if data.user?
        landingView.loggedIn(data.user?)
        landingView.on 'ready', -> @trigger 'start', data.user
      else
        vent.offline = true
        app.main.show(loginView)
        loginView.on 'submit', (username) => landingView.trigger 'start', username: username


  url = "http://localhost:9000"
  if window.location.origin.match(/localhost/) is null then url = "http://wordwar.memrise.com"
  socket = io.connect(url)

  socket.on 'error', ({msg}) -> console.log "ERROR #{msg}"

  landingView.on 'start', (user) =>
    thisPlayer = new PlayerController username: user.username, local: true
    gameLayout = new GameLayout socket: socket, thisPlayerController: thisPlayer

    app.main.show(gameLayout)

    thisPlayer.on 'model:fetched', ->
      gameLayout.thisPlayer.show(@playerLayout)
      @trigger("view:rendered")

    socket.emit 'register', user: user.username

    socket.on 'registered', ->
      socket.emit 'getid', {}

      socket.on 'disconnect', -> vent.trigger 'other:disconnect'

      socket.on 'otherid', ({id, user, first}) ->

        thatPlayer = new PlayerController username: user, local: false
        gameLayout.thatPlayerController = thatPlayer
        gameLayout.thisStarts = not first

        thatPlayer.on 'model:fetched', ->
          gameLayout.thatPlayer.show(@playerLayout)
          @trigger("view:rendered")

        vent.on "game:starting", (view) ->
          app.game.show(view)

  return app
