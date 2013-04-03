define ["marionette"], 
(Marionette) ->

  class LoginView extends Marionette.Layout
    
    id: "login"

    className: "span12"

    template: "#loginTemplate"

    initialize: ->
