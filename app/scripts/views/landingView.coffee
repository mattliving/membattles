define [
  "helpers/vent",
  "marionette"
],
(vent, Marionette) ->

  class LandingView extends Marionette.ItemView

    id: "landing"

    className: "span12"

    template: "#landingTemplate"
