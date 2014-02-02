define [], () ->

  logger =
    log: (level, msg) ->
      if console? and console[level]? and msg? then console[level](msg)
    debugEnabled: false
    infoEnabled: true
    warnEnabled: true
    errorEnabled: true

  for level in ['debug', 'info', 'warn', 'error']
    do (level) ->
      logger[level] = (msg) ->
        @log(level, msg) if @[level + 'Enabled']
      return

  return logger
