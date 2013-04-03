define [
	"marionette", 
	"views/emptyView", 
	"views/courseView"], 
(Marionette, EmptyView, CourseView) ->

  class CoursesView extends Marionette.CollectionView

    tagName: "ul"

    className: "nav nav-tabs nav-stacked"

    # emptyView: EmptyView
    itemView: CourseView

    initialize: ->
      # @on "itemview:selected", (view) ->
      #   console.log view

   	# vent.on("nodeClicked", (d) ->
    # 	@collection.reset(ResourceData)
    # )

  CoursesView