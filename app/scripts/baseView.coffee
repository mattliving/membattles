define ["app", "baseView"], (App, BaseView) ->
  
  class BaseView extends Backbone.View
    
    initialize: ->
      @model.on "change", @render, this
      @model.on "destroy", @cleanup, this

    render: ->
      @$el.html @template(@model.toJSON())
      this

    postInitialize: ->

    postRender: ->
    
    cleanup: ->
      @undelegateEvents()
      @model.off null, null, this
      @remove()
      
  BaseView
