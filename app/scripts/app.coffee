define ["jquery", "backbone", "underscore", "membattle", "player", "playerView"], 
($, Backbone, _, Membattle, Player, PlayerView) ->

  window.requestAnimFrame = do ((callback) ->
    window.requestAnimationFrame || window.webkitRequestAnimationFrame || window.mozRequestAnimationFrame || window.oRequestAnimationFrame || window.msRequestAnimationFrame || (callback) -> window.setTimeout(callback, 1000 / 60)
  )
  
  player1 = new Player(
    user:
      username: "matthew.livingston"
  )
  player2 = new Player(
    user:
      username: "alxhill"
  )
  player1.fetch()
  player2.fetch()
  player1 = new PlayerView(model: player1)
  player2 = new PlayerView(model: player2)

  membattle = new Membattle(player1, player2)
  membattle.startAnimation()
