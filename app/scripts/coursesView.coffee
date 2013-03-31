define [
	"marionette", 
	"emptyView", 
	"courseView"], 
(Marionette, EmptyView, CourseView) ->

  class CoursesView extends Marionette.CollectionView

    template: $("")
    tagName: "ul"

    className: "nav nav-tabs nav-stacked"

    # emptyView: EmptyView
    itemView: CourseView

   	# vent.on("nodeClicked", (d) ->
    # 	@collection.reset(ResourceData)
    # )

  CoursesView