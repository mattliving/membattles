define [
  "marionette",
  "vent",
  "items/plant",
  "items/cannon",
  "models/player",
  "collections/courses",
  "views/playerLayout",
  "views/playerView",
  "views/coursesView",
  "items/textItem"
],
(Marionette, vent, Plant, Cannon, Player, Courses, PlayerLayout, PlayerView, CoursesView, TextItem) ->

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
        # hacky way of not showing the ready button if the other user is ready on load
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

      console.log "initialized"

      # more permanent solution to this is needed.
      @cannon = new Cannon
        pos:
          y: @floor.pos.y-4
          x: if @local then 600 else 40
        scale: 1.2
        active: true
        mirrored: @local

      # temporary till we get scaling working
      # textPos =
      #   x: @cannon.pos.x+@cannon.img.width
      #   y: @cannon.pos.y-@cannon.img.height

      # if @cannon.mirrored then textPos.x += 600

      # textOptions =
      #   pos: textPos
      #   active: true
      #   force:
      #     x: if @local then -2400 else 2400
      #     y: -3000
      #   floor: @floor

      @on 'next', ->
        console.log "next"
        # look into the memory impact of this - pretty sure the old object will
        # be hanging around as it's still in Item.items
        @currentTextItem?.active = false
        @currentTextItem = new TextItem
          pos:
            # the end part adds 600 if cannon is mirrored, otherwise adds nothing
            x: @cannon.pos.x+@cannon.img.width + @cannon.mirrored * 600
            y: @cannon.pos.y-@cannon.img.height
          force:
            x: if @local then -2400 else 2400
            y: -3000
          active: true
          floor: @floor
          model: @things.getNext()

        # set up and bubble events from the newly created object
        @listenTo @currentTextItem, 'inactive', (success) ->
          console.log "inactive"
          @trigger 'endTurn', success

        @listenTo @currentTextItem, 'exploded', (text, success) ->
          console.log "exploded"
          @trigger 'exploded', text, success

        @playerView.model.setCurrentPlayer()

      @on 'guess', (guess) ->
        console.log "guess"
        if @currentTextItem.active
          @currentTextItem.success  = @currentTextItem.model.checkAnswer(guess)
          @currentTextItem.collided = true



      @on 'endTurn', (success) ->
        console.log "endTurn"
        model = @playerView.model
        model.setCurrentPlayer()
        unless success
          model.decLives()
          if model.get('lives') <= 0
            vent.trigger 'game:ending', model.get('username')
        else
          model.incPoints()

      console.log "finished initializing"

