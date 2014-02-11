define ['requestAnimationFrame', 'underscore'], (requestAnimationFrame, _) ->

  class RafHeartbeat

    constructor: () ->
      @isRunning = no

    start: (updateFn = _.identity, renderFn = _.identity, updateInterval = 1 / 20) ->
      @isRunning = yes

      lastFrameTime = Date.now()
      lastUpdateTime = 0
      updateIntervalMs = @updateInterval * 1000

      fn = () =>
        requestAnimationFrame(fn) if @isRunning

        now = Date.now()

        if (now - lastUpdateTime) >= updateIntervalMs
          updateFn()
          lastUpdateTime = now

        renderFn()

        lastFrameTime = now
        return

      fn()
      return

    stop: () ->
      @isRunning = no
      return