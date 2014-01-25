define ['requestAnimationFrame', 'newton'], (requestAnimationFrame, Newton) ->

  canvasResolution = [1920, 1080]
  metersPerPixel = 1 / 64

  class Engine

    constructor: (@entities = []) ->
      @canvas = null
      @context = null
      @time = 0
      @updateArgs = {deltaTime: 0, time: 0, counter: 0, engine: this}
      @updateInterval = 1000 / 20
      @renderArgs = {deltaTime: 0, time: 0, counter: 0, engine: this}
      @timeOfLastRender = 0.0
      @sim = null

    createCanvas: (parentElement) ->
      if @canvas?
        throw new Error 'canvas already exists.'

      @canvas = document.createElement('canvas')

      if not @canvas.getContext?
        @destroyCanvas()
        throw new Error 'canvas is not supported.'

      @canvas.width = canvasResolution[0]
      @canvas.height = canvasResolution[1]
      @context = @canvas.getContext('2d')

      if not @context?
        @destroyCanvas()
        throw new Error 'No 2d context found.'

      parentElement?.appendChild @canvas
      return @canvas

    destroyCanvas: () ->
      @context = null

      @canvas?.parentNode?.removeChild(@canvas)
      @canvas = null

      return

    start: () ->
      if @sim?
        return

      @sim = Newton.Simulator @update.bind(this), @render.bind(this), 1000 / @updateInterval
      @sim.start()
      return

    stop: () ->
      @sim?.stop()
      @sim = null
      @time = 0
      @timeOfLastRender = 0.0
      return

    update: (deltaTime) ->
      deltaTime = deltaTime / 1000.0
      @time += deltaTime

      args = @updateArgs
      args.deltaTime = deltaTime
      args.time = @time
      args.counter += 1

      entity.update args for entity in @entities

      return

    render: (deltaTime) ->
      deltaTime = deltaTime / 1000.0
      @timeOfLastRender += deltaTime

      args = @renderArgs
      args.deltaTime = deltaTime
      args.time = @time
      args.counter += 1
      args.context = @context
      args.alpha = (@timeOfLastRender - @time) / @updateInterval

      entity.render args for entity in @entities

      return
