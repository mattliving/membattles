define ["marionette"], 
(Marionette) ->

	class NoItemsView extends Marionette.ItemView
		
		template: $("#noItemsTemplate")