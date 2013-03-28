define ["app", "baseView"], (App, BaseView) ->

  class PlayerView extends BaseView

    template: _.template(
      $("#playerTemplate").html()
    )