define ["app", "movingtext"], (App, MovingText) ->

  class Membattle

    prob = Math.random()

    canvas = $("canvas")[0]
    ctx = canvas.getContext("2d")
    medium_plants = []
    large_plants  = []
    text_elements = []
    data =
      sausage: "saucisson"
      frog: "grenoille"
      cat: "chat"
      fish: "poisson"
      tortoise: "tortue"
      mother: "mere"
      computer: "l'ordinateur"

    constructor: ->
      initPlants(large_plants, Math.floor(prob*4)+2, "large_plant")
      initPlants(medium_plants, Math.floor(prob*3)+1, "medium_plant")

    startAnimation: ->
      for eng, french of data
        text_elements.push new MovingText(french, ctx, 50, 400, 2000, -3000)

      i = 0
      setInterval(->
        if i < text_elements.length
          text_elements[i++].active = true
      , 1000)

      animate(canvas, ctx, Date.now())

    initPlants = (a, n, type) ->
      for i in [1..n]
        img = new Image()
        if type is "medium_plant"
          img.src = "/images/medium_plant.png"
        else
          img.src = "/images/large_plant.png" 
        img.dataset.type = type
        img.dataset.x = i
        img.dataset.y = (if type is "medium_plant" then 280 else 256)
        img.onload = onImageLoad
        a.push img

    onImageLoad = ->
      if @dataset.type is "medium_plant"
        @dataset.x = +@dataset.x + large_plants.length + 0.1
      @dataset.x = @dataset.x*@width*0.35
      ctx.drawImage(@, @dataset.x, @dataset.y, @width*0.3, @height*0.3) 


    animate = (canvas, ctx, lastTime) ->
      time = Date.now()
      dx = time - lastTime
      while dx > 0 # at the moment we do one tick per millisecond
        ctx.clearRect(0, 0, canvas.width, canvas.height)
        
        for text in text_elements
          if text? and text.active
            text.update()

            text.draw()

            text.applyForce(0, 9.8)

            if text.x > canvas.width - 100 or text.y > canvas.height - 100
              text_elements.splice(text_elements.indexOf(text), 1)
        dx--

      requestAnimFrame ->
        animate(canvas, ctx, time)
