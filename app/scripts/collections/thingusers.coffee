define ["app", "models/thinguser"],
(App, Thinguser) ->
  
  class Thingusers extends Backbone.Collection

    url: "http://www.memrise.com/api/course/get/?levels_with_thingusers=true&course_id="

    parse: (response) ->
      console.log response.course.levels[0]

    model: Thinguser

  Thingusers
