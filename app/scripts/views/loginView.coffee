define ["marionette"],
(Marionette) ->

  class LoginView extends Marionette.Layout

    id: "login"

    className: "span12"

    ui:
      inputEmail: "#inputEmail"

    template: "#loginTemplate"

    events:
      "click .btn": "login"

    login: (e) ->
      e.preventDefault()
      @trigger 'submit', @ui.inputEmail.val()
