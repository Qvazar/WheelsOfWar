define ['requestAnimationFrame', 'newton', 'underscore'], (requestAnimationFrame, Newton, _) ->

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
      {@rootComponent, @updateInterval} = args if args?

      @time = 0
      @updateInterval ?= 1000 / 20
      @timeOfLastRender = 0.0
      @sim = null

      @updateContext = {deltaTime: 0, time: 0, counter: 0, engine: this}
      @renderContext = {deltaTime: 0, time: 0, counter: 0, engine: this, toMeters, toPixels}

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

      context = @updateContext
      context.deltaTime = deltaTime
      context.time = @time
      context.counter += 1

      @rootComponent.update(context) if @rootComponent?

      return

    render: (deltaTime) ->
      deltaTime = deltaTime / 1000.0
      @timeOfLastRender += deltaTime

      context = @renderContext
      context.deltaTime = deltaTime
      context.time = @time
      context.counter += 1
      context.alpha = (@timeOfLastRender - @time) / @updateInterval

      @rootComponent.render(context) if @rootComponent?

      return
