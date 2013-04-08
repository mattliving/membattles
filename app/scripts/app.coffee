define [
  "marionette",
  "views/gameLayout",
  "views/loginView",
  "playerManager",
  "socket.io"
],
(Marionette, GameLayout, LoginView, PlayerManager, io) ->

  window.requestAnimFrame = do ((callback) ->
    window.requestAnimationFrame || window.webkitRequestAnimationFrame || window.mozRequestAnimationFrame || window.oRequestAnimationFrame || window.msRequestAnimationFrame || (callback) -> window.setTimeout(callback, 1000 / 60)
  )

  app = new Marionette.Application()

  app.addRegions
    main: "#main"

  loginView = new LoginView()

  app.addInitializer ->
    app.main.show(loginView)

  socket = io.connect(window.location.origin)

  loginView.on 'submit', (username) =>
    thisPlayer = new PlayerManager username, true
    gameLayout = new GameLayout args: [thisPlayer]

    app.main.show(gameLayout)

    thisPlayer.on 'model:fetched', ->
      gameLayout.thisPlayer.show(@playerView)
      @trigger("view:rendered")

    socket.emit 'register', user: username

    socket.on 'registered', ->
      console.log "registered"
      socket.emit 'getid', {}
      socket.on 'otherid', ({id, user, first}) ->

        console.log id, user, first

        thatPlayer = new PlayerManager user, false
        gameLayout.args.push thatPlayer, socket

        thatPlayer.on 'model:fetched', ->
          gameLayout.thatPlayer.show(@playerView)
          @trigger("view:rendered")

  return app
