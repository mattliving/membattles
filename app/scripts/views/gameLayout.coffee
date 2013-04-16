define [
  'marionette',
  'helpers/vent',
  'views/inputView',
  'views/membattle',
  'models/course',
  'collections/things'
],
(Marionette, vent, InputView, Membattle, Course, Things) ->

  class GameLayout extends Marionette.Layout

    className: 'span12'

    template: '#gameTemplate'

    ui:
      input: '#inputArea'

    regions:
      thisPlayer: '#thisPlayer'
      thatPlayer: '#thatPlayer'
      input:      '#inputArea'
      game:       '#game'

    initialize: ({@socket, @thisPlayerController}) ->
      @thisPlayer.on 'show', (layout) =>
        layout.player.on 'show', (view) =>
          view.on 'ready', =>
            @thisPlayerReady = true
            view.trigger 'fetch:data'
          view.on 'course:fetched', (model) =>
            @thisPlayerController.trigger 'ready'
            @socket.emit 'ready', model.toJSON()
          view.on 'things:fetched', (@thisPlayerThings) =>
            @thisPlayerController.things = @thisPlayerThings
            @socket.emit 'things', @thisPlayerThings.toJSON()
            @trigger 'ready'

      @socket.on 'ready', (selectedCourse) =>
        @thatPlayerController.playerView.selectedCourse = new Course(selectedCourse)
        @thatPlayerReady = true
        @thatPlayerController.trigger 'ready'

      @socket.on 'things', (things) =>
        @thatPlayerThings = new Things(things)
        @thatPlayerController.things = @thatPlayerThings
        @trigger 'ready'

      @on 'ready', =>
        if @thisPlayerThings and @thatPlayerThings
          @startGame()

      vent.on 'game:ended', (endMsg) =>
        @endGame(endMsg)

    startGame: ->
      @input.show new InputView()
      # @ui.input.append('<h2>Game starting in 3 seconds!</h2>')
      # setTimeout (() =>
      #   @ui.input.children('h2').text('Game starting in 2 seconds!')
      # ), 1000
      # setTimeout (() =>
      #   @ui.input.children('h2').text('Game starting in 1 seconds!')
      # ), 2000
      # setTimeout (() =>
      #   @ui.input.children('h2').remove()
      membattle = new Membattle(@socket, @input.currentView, @thisPlayerController, @thatPlayerController, @thisStarts)
      @game.show(membattle)
      membattle.start()
      # ), 3000

    endGame: (endMsg) ->
      # @input.currentView.close()
      # @game.currentView.close()
      # @input.$el.append("<h1>#{endMsg}</h1>")
