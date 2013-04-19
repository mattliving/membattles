define [
  "helpers/vent",
  "marionette"
],
(vent, Marionette) ->

  class LandingView extends Marionette.ItemView

    id: "landing"

    className: "span6 offset6"

    template: "#landingTemplate"

    events:
      "click #start": "startGame"

    startGame: (e) ->
      e.preventDefault()
      @trigger('start')

    loggedIn: (isLoggedIn) ->
      if isLoggedIn
        @$el.find("logged-in").removeClass("hidden")
      else
        @$el.find("logged-out").removeClass("hidden")
