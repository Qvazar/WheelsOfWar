define ['./log', 'underscore'], (log, _) ->

  class Engine

    constructor: (args) ->
      {@rootComponent, @updateInterval, @heartbeat} = args if args?

      @time = 0
      @updateInterval ?= 1 / 20
      @timeOfLastUpdate = null
      @timeOfLastRender = null

      @updateContext = {deltaTime: 0, time: 0, counter: 0, engine: this}
      @renderContext = {deltaTime: 0, time: 0, counter: 0, engine: this}

    start: () ->
      @heartbeat.start _.bind(@update, this), _.bind(@render, this), @updateInterval
      return

    stop: () ->
      @heartbeat.stop()
      @time = 0
      @timeOfLastUpdate = null
      @timeOfLastRender = null
      return

    update: () ->
      now = Date.now()
      deltaTime = (now - @timeOfLastUpdate) / 1000.0
      @time += deltaTime

      context = @updateContext
      context.deltaTime = deltaTime
      context.time = @time
      context.counter += 1

      @rootComponent?.update(context)

      @timeOfLastUpdate = now
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
