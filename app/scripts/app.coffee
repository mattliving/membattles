define [
  "marionette", 
  "membattle", 
  "models/text",
  "collections/texts",
  "player", 
  "playerView",
  "courses",
  "coursesView"], 
(Marionette, Membattle, Text, Texts, Player, PlayerView, Courses, CoursesView) ->

  window.requestAnimFrame = do ((callback) ->
    window.requestAnimationFrame || window.webkitRequestAnimationFrame || window.mozRequestAnimationFrame || window.oRequestAnimationFrame || window.msRequestAnimationFrame || (callback) -> window.setTimeout(callback, 1000 / 60)
  )
  app = new Marionette.Application()

  player1 = new Player(
    username: "matthew.livingston"
  )
  player2 = new Player(
    username: "alxhill"
    position: "right" # shouldn't the view store the position?
  )

  player1View = new PlayerView(
    model: player1
  )
  player2View = new PlayerView(
    model: player2
  )

  player1Courses = new Courses()
  player1Courses.url += player1.get("username")
  player2Courses = new Courses()
  player2Courses.url += player2.get("username")

  app.addRegions
    player1: "#player1"
    player2: "#player2"

  app.addInitializer ->
    player1.fetch(
      success: ->
        small = player1.get("photo_small").replace("large", "small")
        player1.set("photo_small", small)
        # app.player1.show(player1View)
    ).done ->
      player1Courses.fetch(
        success: ->
          player1CoursesView = new CoursesView(
            collection: player1Courses
          )
          player1View.courses.show(player1CoursesView)
      )
    player2.fetch(
      success: ->
        small = player2.get("photo_small").replace("large", "small")
        player2.set("photo_small", small)
        # app.player2.show(player2View)
    ).done ->
      player2Courses.fetch(
        success: ->
          player2CoursesView = new CoursesView(
            collection: player2Courses
          )
          player2View.courses.show(player2CoursesView)
      )

  
  window.Text = Text
  window.Texts = Texts
  
  membattle = new Membattle()
  membattle.startAnimation()

  return app
