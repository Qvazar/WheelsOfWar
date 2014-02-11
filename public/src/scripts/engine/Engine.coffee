define ['./log', 'newton', 'underscore'], (log, Newton, _) ->

  class Engine

    constructor: (args) ->
      {@rootComponent, @updateInterval} = args if args?

      @time = 0
      @updateInterval ?= 1000 / 20
      @timeOfLastUpdate = null
      @timeOfLastRender = null
      @sim = null

      @updateContext = {deltaTime: 0, time: 0, counter: 0, engine: this}
      @renderContext = {deltaTime: 0, time: 0, counter: 0, engine: this}

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
      @timeOfLastRender = null
      return

    update: (deltaTime) ->
      deltaTime = deltaTime / 1000.0
      @time += deltaTime

      context = @updateContext
      context.deltaTime = deltaTime
      context.time = @time
      context.counter += 1

      @rootComponent?.update(context)

      @timeOfLastUpdate = Date.now()

      return

    render: () ->
      now = Date.now()
      timeSinceUpdate = now - @timeOfLastUpdate

      context = @renderContext
      context.deltaTime = now - @timeOfLastRender
      context.time = @time
      context.counter += 1
      context.alpha = timeSinceUpdate / @updateInterval
      context.fps = Math.round 1000 / context.deltaTime

      @rootComponent?.render(context)
      @timeOfLastRender = now

      return
