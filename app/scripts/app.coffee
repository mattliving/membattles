define ["jquery", "backbone", "underscore", "membattle"], 
($, Backbone, _, Membattle) ->
  membattle = new Membattle()
  setTimeout( -> 
    membattle.update()
  , 1000)