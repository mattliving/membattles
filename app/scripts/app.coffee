define ["jquery", "backbone", "underscore", "membattle", "player", "playerView"], 
($, Backbone, _, Membattle, Player, PlayerView) ->

  window.requestAnimFrame = do ((callback) ->
    window.requestAnimationFrame || window.webkitRequestAnimationFrame || window.mozRequestAnimationFrame || window.oRequestAnimationFrame || window.msRequestAnimationFrame || (callback) -> window.setTimeout(callback, 1000 / 60)
  )
  
  playerModel1 = new Player(
    user:
      username: "matthew.livingston"
  )
  playerModel2 = new Player(
    user:
      username: "alxhill"
  )
  playerModel1.fetch()
  playerModel2.fetch()
  playerView1 = new PlayerView(model: playerModel1)
  playerView2 = new PlayerView(model: playerModel2)

  membattle = new Membattle(playerView1, playerView2)
  membattle.startAnimation()
