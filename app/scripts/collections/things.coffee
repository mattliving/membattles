define ["app", "models/thing"],
(App, Thing) ->
  
  class Things extends Backbone.Collection

    # url: 
    model: Thing

  Things
