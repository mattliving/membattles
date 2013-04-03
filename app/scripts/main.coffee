require.config
  paths:
    backbone: "../components/backbone/backbone-min"
    underscore: "../components/underscore/underscore-min"
    jquery: "../components/jquery/jquery.min"
    marionette: "../components/marionette/lib/backbone.marionette.min"
    text: "../components/requirejs-text/text"
    tpl: "../components/requirejs-tpl/tpl"
    'backbone.wreqr': "../components/backbone.wreqr/lib/amd/backbone.wreqr.min"
    'bootstrap.button': "../components/bootstrap/js/bootstrap-button"

  shim:
    jquery: 
      exports: "jQuery"
    underscore: 
      exports: "_"
    backbone: 
      deps: ["jquery", "underscore"]
      exports: "Backbone"
    marionette: 
      deps: ["jquery", "underscore", "backbone"]
      exports: "Marionette"
    "bootstrap.button":
      deps: ["jquery"]

require ["app", "backbone"], (App, Backbone) ->

  App.start()
  Backbone.history.start()
