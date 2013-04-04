define [
  "marionette",
  "views/gameLayout",
  "views/loginView",
  "models/player",
  "views/playerView",
  "collections/courses",
  "views/coursesView"],
(Marionette, GameLayout, LoginView, Player, PlayerView, Courses, CoursesView) ->

  window.requestAnimFrame = do ((callback) ->
    window.requestAnimationFrame || window.webkitRequestAnimationFrame || window.mozRequestAnimationFrame || window.oRequestAnimationFrame || window.msRequestAnimationFrame || (callback) -> window.setTimeout(callback, 1000 / 60)
  )

  app        = new Marionette.Application()
  # loginView  = new LoginView()
  gameLayout = new GameLayout()

  player1Model = new Player(
    username: "matthew.livingston"
  )
  player2Model = new Player(
    username: "edcooke"
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
    main: "#main"

  app.addInitializer () ->
    app.main.show(gameLayout)
    player1Model.fetch(
      success: ->
        small = player1Model.get("photo_small").replace("large", "small")
        player1Model.set("photo_small", small)
        gameLayout.player1.show(player1View)
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
        gameLayout.player2.show(player2View)
    ).done () ->
      player2Courses.fetch(
        success: ->
          player2CoursesView = new CoursesView(
            collection: player2Courses
          )
          player2View.courses.show(player2CoursesView)
      )

  return app
