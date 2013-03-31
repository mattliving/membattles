define ["app", "course"],
(App, Course) ->
  
  class Courses extends Backbone.Collection

    model: Course

  Courses
