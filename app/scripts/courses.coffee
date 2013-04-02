define ["app", "course"],
(App, Course) ->
  
  class Courses extends Backbone.Collection

    url: "http://www.memrise.com/api/user/courses_learning/?user_username="

    parse: (response) ->
      response.courses_learning

    model: Course

  Courses
