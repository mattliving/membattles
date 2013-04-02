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
  app = new Marionette.Application()

  player1Model = new Player(
    username: "matthew.livingston"
  )
  player2Model = new Player(
    username: "alxhill"
    position: "right"
  )

  player1View = new PlayerView(
    model: player1Model
  )
  player2View = new PlayerView(
    model: player2Model
  )

  player1Courses = new Courses()
  player1Courses.url += player1Model.get("username")
  player2Courses = new Courses()
  player2Courses.url += player2Model.get("username")

  app.addRegions
    player1: "#player1"
    player2: "#player2"

  app.addInitializer () ->
    player1Model.fetch(
      success: ->
        small = player1Model.get("photo_small").replace("large", "small")
        player1Model.set("photo_small", small)
        app.player1.show(player1View)
    ).done () ->
      player1Courses.fetch(
        success: ->
          player1CoursesView = new CoursesView(
            collection: player1Courses
          )
          player1View.courses.show(player1CoursesView)
      )
    player2Model.fetch(
      success: ->
        small = player2Model.get("photo_small").replace("large", "small")
        player2Model.set("photo_small", small)
        app.player2.show(player2View)
    ).done () ->
      player2Courses.fetch(
        success: ->
          player2CoursesView = new CoursesView(
            collection: player2Courses
          )
          player2View.courses.show(player2CoursesView)
      )

  membattle = new Membattle()
  membattle.startAnimation()

  return app
