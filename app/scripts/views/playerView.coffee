define ["app", "marionette", "bootstrap_button"], 
(App, Marionette) ->

  class PlayerView extends Marionette.Layout

    className: "media well"
        
    template: "#playerTemplate"

    events: 
      "click #courses li" : "toggleSelected"
      "click .btn" : "toggleButton"

    regions: 
      courses: "#courses"

    initialize: ->
      $(".btn").button()

    toggleSelected: (e) ->
      $this = $(e.currentTarget)
      $this.parent().children("li.active").removeClass "active"
      $this.addClass "active"

    toggleButton: (e) ->
      console.log $(e.currentTarget)
