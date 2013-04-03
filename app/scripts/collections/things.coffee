define ["app", "models/thing"],
(App, Thing) ->
  
  class Things extends Backbone.Collection

    model: Thing

  Things
