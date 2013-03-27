define ["jquery", "backbone", "underscore", "membattle"], 
($, Backbone, _, Membattle) ->
  window.requestAnimFrame = do ((callback) ->
    window.requestAnimationFrame || window.webkitRequestAnimationFrame || window.mozRequestAnimationFrame || window.oRequestAnimationFrame || window.msRequestAnimationFrame || (callback) -> window.setTimeout(callback, 1000 / 60)
  )
  
  membattle = new Membattle()

  setTimeout(-> 
    membattle.startAnimation()
  , 1000)
