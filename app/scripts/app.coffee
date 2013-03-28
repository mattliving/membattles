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
    position: "right"
    user:
      username: "edcooke"
  )
  playerModel1.fetch(
    success: ->
      small = playerModel1.get("user").photo_small.replace("large", "small")
      user  = playerModel1.get("user")
      user.photo_small = small
      playerModel1.set("user", user)
      playerView1 = new PlayerView(
        el: $("#player1")
        model: playerModel1
      )
  )
  playerModel2.fetch(
    success: ->
      small = playerModel2.get("user").photo_small.replace("large", "small")
      user  = playerModel2.get("user")
      user.photo_small = small
      playerModel2.set("user", user)
      playerView2 = new PlayerView(
        el: $("#player2")
        model: playerModel2
      )
  )
  membattle = new Membattle()
  membattle.startAnimation()