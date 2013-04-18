define [
  "helpers/vent",
  "marionette"
],
(vent, Marionette) ->
  class LoadingView extends Marionette.ItemView
    id: "loading"

    className: "span12"

    template: "#loadingTemplate"
