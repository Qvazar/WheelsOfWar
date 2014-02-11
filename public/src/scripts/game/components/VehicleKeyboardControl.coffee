define ['/engine/log', '/engine/components/Component'], (log, Component) ->

  class VehicleKeyboardControl extends Component
    constructor: (args) ->
      {@forwardKey, @reverseKey, @turnLeftKey, @turnRightKey, @vehicleComponent} = args
      @forwardKey ?= 'w'
      @turnLeftKey ?= 'a'
      @reverseKey ?= 's'
      @turnRightKey ?= 'd'

    update: (ctx) ->
      kbd = ctx.keyboard;

      if @vehicleComponent?
        if kbd.byKeyName(@forwardKey).isDown
          # add forward momentum
          log.warn 'Not implemented'

        if kbd.byKeyName(@reverseKey).isDown
          # add reverse momentum
          log.warn 'Not implemented'

        if kbd.byKeyName(@turnLeftKey).isDown
          # turn the wheel left
          log.warn 'Not implemented'

        if kbd.byKeyName(@turnRightKey).isDown
          # turn the wheel right
          log.warn 'Not implemented'
