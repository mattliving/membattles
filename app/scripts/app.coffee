define ["jquery", "backbone", "underscore", "membattle", "player", "playerView"], 
($, Backbone, _, Membattle, Player, PlayerView) ->

  window.requestAnimFrame = do ((callback) ->
    window.requestAnimationFrame || window.webkitRequestAnimationFrame || window.mozRequestAnimationFrame || window.oRequestAnimationFrame || window.msRequestAnimationFrame || (callback) -> window.setTimeout(callback, 1000 / 60)
  )
  
  player1 = new PlayerView(model: new Player())
  player2 = new PlayerView(model: new Player())

  membattle = new Membattle(player1, player2)
  membattle.startAnimation()
