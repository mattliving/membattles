define [
  "marionette",
  "helpers/vent",
  "items/plant",
  "items/cannon",
  "models/player",
  "collections/courses",
  "views/playerLayout",
  "views/playerView",
  "views/coursesView",
  "items/textItem",
  "items/letter"
],
(Marionette, vent, Plant, Cannon, Player, Courses, PlayerLayout, PlayerView, CoursesView, TextItem, Letter) ->

  class PlayerController extends Marionette.Controller

    constructor: (username, @local) ->
      pos                = if @local then "left" else "right"
      @playerModel       = new Player username: username, position: pos
      @playerLayout      = new PlayerLayout()
      @playerView        = new PlayerView model: @playerModel, disabled: not @local
      @playerCoursesView = new CoursesView(collection: new Courses())
      @playerCoursesView.collection.url += @playerModel.get("username")

      @playerModel.fetch success: (model) =>
        model.set("photo_small", model.get("photo_small").replace("large", "small"))
        @trigger("model:fetched")
        if @ready then @playerView.off("show")
        @playerLayout.player.show(@playerView)

      @on 'view:rendered', ->
        unless @ready
          @playerCoursesView.collection.fetch success: (model) =>
            @playerLayout.courses.show(@playerCoursesView)
        else
          @playerLayout.courses.show(@playerCoursesView)

      @on 'ready', ->
        @ready = true
        @playerCoursesView.collection.reset(@playerView.selectedCourse)

    initialize: (@floor) ->

      @cannon = new Cannon
        axis: @floor.pos.x
        pos:
          x: @floor.pos.x*0.2
          y: @floor.pos.y
        active: true
        mirrored: @local

      @spawnPos = y: @cannon.pos.y - @cannon.img.height - 100
      if @local
        @spawnPos.x = 2*@cannon.axis-@cannon.pos.x
      else
        @spawnPos.x = @cannon.pos.x

      @on 'next', ->
        # inactive items will be removed from the items array
        @currentTextItem?.active = false

        # create the new text item at the mouth of the cannon
        @currentTextItem = new TextItem
          pos: _.clone @spawnPos
          force:
            x: if @local then -2400 else 2400
            y: -3000
          active: true
          floor: @floor
          model: @things.getNext()

        # set up and bubble events from the newly created object
        @listenTo @currentTextItem, 'inactive', (success) ->
          @trigger 'endTurn', success

        @listenTo @currentTextItem, 'exploded', (text, success) ->
          @trigger 'exploded', text, success

        @playerView.model.setCurrentPlayer()

      @on 'guess', (guess) ->
        if @currentTextItem.active
          @currentTextItem.success  = @currentTextItem.model.checkAnswer(guess)
          @currentTextItem.collided = true

      @on 'endTurn', (success) ->
        model = @playerView.model
        model.setCurrentPlayer()
        unless success
          model.decLives()
          if model.get('lives') <= 0
            vent.trigger 'game:ending', model.get('username')
        else
          model.incPoints(45)

    getData: ->
      text: @currentTextItem.model.get("text")
      translation: @currentTextItem.model.get("translation")

    fireLetter: (letter, input, startPos) ->
      # these are used to calculate the force needed to make it go to the word
      # TODO: make it move to where the word will be, rather than where it is
      {x: tx, y: ty} = @currentTextItem.pos
      {x: sx, y: sy} = startPos
      letter = new Letter
        pos: x: sx, y: sy
        force: x: 70*(tx-sx), y: 70*(ty-sy)
        gravityOn: false
        letter: letter
        text: @currentTextItem
      letter.on 'collided', =>
        if @currentTextItem.model.checkPartialAnswer(input)
          letter.active = false
        else
          letter.bounce()
