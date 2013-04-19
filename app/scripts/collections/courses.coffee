define ["app", "models/course"],
(App, Course) ->

  class Courses extends Backbone.Collection

    url: "http://www.memrise.com/api/user/courses_learning/?user_username="

    model: Course

    parse: (response) ->
      response.courses_learning



