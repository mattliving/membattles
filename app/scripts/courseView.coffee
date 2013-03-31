define ["marionette"], 
(Marionette) ->
  
  class CourseView extends Marionette.ItemView
  	
  	tagName: "li"

  	template: $("#courseTemplate")

  CourseView