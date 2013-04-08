define [
  "marionette",
  "views/gameLayout",
  "views/loginView",
  "playerManager"
],
(Marionette, GameLayout, LoginView, PlayerManager) ->

  window.requestAnimFrame = do ((callback) ->
    window.requestAnimationFrame || window.webkitRequestAnimationFrame || window.mozRequestAnimationFrame || window.oRequestAnimationFrame || window.msRequestAnimationFrame || (callback) -> window.setTimeout(callback, 1000 / 60)
  )

  app = new Marionette.Application()

  thisPlayer = new PlayerManager "matthew.livingston", true
  thatPlayer = new PlayerManager "alxhill", false

  gameLayout = new GameLayout(thisPlayerManager: thisPlayer, thatPlayerManager: thatPlayer)

  app.addRegions
    main: "#main"

  app.addInitializer ->
    app.main.show(gameLayout)
    thisPlayer.on 'model:fetched', ->
      gameLayout.thisPlayer.show(@playerView)
      @trigger("view:rendered")

    thatPlayer.on 'model:fetched', ->
      gameLayout.thatPlayer.show(@playerView)
      @trigger("view:rendered")

  return app
