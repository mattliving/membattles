define ["marionette"],
(Marionette) ->

  class LoginView extends Marionette.Layout

    id: "login"

    className: "span12"

    ui:
      inputUsername: "#inputUsername"

    template: "#loginTemplate"

    events:
      "click .btn.btn-large": "login"

    login: (e) ->
      e.preventDefault()
      @trigger 'submit', @ui.inputUsername.val()
