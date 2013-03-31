define [
  "marionette", 
  "membattle", 
  "player", 
  "playerView",
  "courses",
  "coursesView"], 
(Marionette, Membattle, Player, PlayerView, Courses, CoursesView) ->

  window.requestAnimFrame = do ((callback) ->
    window.requestAnimationFrame || window.webkitRequestAnimationFrame || window.mozRequestAnimationFrame || window.oRequestAnimationFrame || window.msRequestAnimationFrame || (callback) -> window.setTimeout(callback, 1000 / 60)
  )

  app     = new Marionette.Application()
  courses = new Courses()

  playerModel1 = new Player(
    user:
      username: "matthew.livingston"
  )
  playerModel2 = new Player(
    position: "right"
    user:
      username: "alxhill"
  )

  app.addRegions
    player1: "#player1"
    player2: "#player2"

  app.addInitializer () ->
    playerView1 = new PlayerView(
      model: playerModel1
    )
    console.log playerView1
    playerView2 = new PlayerView(
      model: playerModel2
    )
    playerModel1.fetch(
      success: ->
        small = playerModel1.get("user").photo_small.replace("large", "small")
        user  = playerModel1.get("user")
        user.photo_small = small
        playerModel1.set("user", user)
        app.player1.show(playerView1)
    )
    playerModel2.fetch(
      success: ->
        small = playerModel2.get("user").photo_small.replace("large", "small")
        user  = playerModel2.get("user")
        user.photo_small = small
        playerModel2.set("user", user)
        app.player2.show(playerView2)
    )

  membattle = new Membattle()
  membattle.startAnimation()

  return app
