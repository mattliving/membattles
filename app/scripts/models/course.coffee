define ["app"], (App) ->

  class Course extends Backbone.Model

    urlRoot: "http://www.memrise.com/api/course/get/?course_id="
      
    defaults:
      description: "",
      creator: {},
      photo: "",
      levels: [],
      num_levels: 0,
      id: null,
      num_things: 0,
      num_learners: 0,
      name: "",
      url: "",
      price_in_cents: 0,
      slug: ""

  Course
