define ['requestAnimationFrame', 'newton', 'underscore'], (requestAnimationFrame, Newton, _) ->

  canvasResolution = [1920, 1080]
  pixelsPerMeter = 64
  metersPerPixel = 1 / pixelsPerMeter

  toPixels = (meters) ->
    if _.isArray(meters)
      pixels = (toPixels meter for meter in meters)
      return pixels
    else return meters * pixelsPerMeter

  toMeters = (pixels) ->
    if _.isArray(pixels)
      meters = (toMeters pixel for pixel in pixels)
      return meters
    else return pixels * metersPerPixel

  class Engine

    constructor: (args) ->
      {@rootElement, @entities} = args
      if not @rootElement
        throw new Error 'rootElement not defined.'

      @entities ?= []

      @canvas = null
      @context = null
      @time = 0
      @updateInterval = 1000 / 20
      @timeOfLastRender = 0.0
      @sim = null

      @updateContext = {deltaTime: 0, time: 0, counter: 0, engine: this}
      @renderContext = {deltaTime: 0, time: 0, counter: 0, engine: this, toMeters, toPixels, @rootElement}

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

      args = @updateContext
      args.deltaTime = deltaTime
      args.time = @time
      args.counter += 1

      entity.update args for entity in @entities

      return

    render: (deltaTime) ->
      deltaTime = deltaTime / 1000.0
      @timeOfLastRender += deltaTime

      args = @renderContext
      args.deltaTime = deltaTime
      args.time = @time
      args.counter += 1
      args.alpha = (@timeOfLastRender - @time) / @updateInterval

      entity.render args for entity in @entities

      return
