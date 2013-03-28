define ["jquery", "backbone", "underscore", "membattle", "player", "playerView"], 
($, Backbone, _, Membattle, Player, PlayerView) ->

  window.requestAnimFrame = do ((callback) ->
    window.requestAnimationFrame || window.webkitRequestAnimationFrame || window.mozRequestAnimationFrame || window.oRequestAnimationFrame || window.msRequestAnimationFrame || (callback) -> window.setTimeout(callback, 1000 / 60)
  )
  
  player1 = new Player("matthew.livingston")
  player2 = new Player("alxhill")

  membattle = new Membattle(player1, player2)
  membattle.startAnimation()
