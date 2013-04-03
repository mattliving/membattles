define [], () ->

  class Thinguser extends Backbone.Model

    defaults:
      ignored: false,
      next_date: "",
      thing_id: null,
      growth_level: 0,
      current_streak: 0,
      total_correct: 0,
      column_b: 2,
      column_a: 1,
      total_incorrect: 0,
      mem_id: null,
      user_id: null,
      interval: 0.0,
      last_date: ""

  Thinguser
