define [], () ->

  class Thing extends Backbone.Model

    # url: ->
    #   "http://www.memrise.com/api/thing/get/?thing_id=" + @get("id")
    
    # parse: (response) ->
    #   response.thing

    defaults:
      absolute_url: "/home/",
      pool_id: null,
      creator_id: null,
      attributes: {},
      id: null,
      columns: {}
