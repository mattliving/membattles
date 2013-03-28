define ["app", "baseView"], (App, BaseView) ->
  
  class BaseView extends Backbone.View
    
    initialize: ->
      @model.on "change", @render, this
      @model.on "destroy", @cleanup, this
      @render()

    render: ->
      @$el.html @template(@model.toJSON())
      console.log @template(@model.toJSON())
      this

    postInitialize: ->

    postRender: ->
    
    cleanup: ->
      @undelegateEvents()
      @model.off null, null, this
      @remove()
      
  BaseView
