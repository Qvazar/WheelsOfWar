define [], () ->

  debugEnabled: false

  logger =
    log: (level, msg) ->
      if console? and console[level]? and msg? then console[level](msg)

    debug: (msg) ->
      @log 'debug', msg if @debugEnabled

  (logger[level] = (msg) -> @log(level, msg)) for level in ['info', 'warn', 'error']

  return logger
