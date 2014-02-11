define ['underscore', '../log', './Component'], (_, log, Component) ->

  KEYCODES_NAMES =
    '8'	:	'backspace'
    '9'	:	'tab'
    '13'	:	'enter'
    '16'	:	'shift'
    '17'	:	'ctrl'
    '18'	:	'alt'
    '19'	:	'pause'
    '20'	:	'caps_lock'
    '27'	:	'escape'
    '33'	:	'page_up'
    '34'	:	'page_down'
    '35'	:	'end'
    '36'	:	'home'
    '37'	:	'left_arrow'
    '38'	:	'up_arrow'
    '39'	:	'right_arrow'
    '40'	:	'down_arrow'
    '45'	:	'insert'
    '46'	:	'delete'
    '48'	:	'0'
    '49'	:	'1'
    '50'	:	'2'
    '51'	:	'3'
    '52'	:	'4'
    '53'	:	'5'
    '54'	:	'6'
    '55'	:	'7'
    '56'	:	'8'
    '57'	:	'9'
    '65'	:	'a'
    '66'	:	'b'
    '67'	:	'c'
    '68'	:	'd'
    '69'	:	'e'
    '70'	:	'f'
    '71'	:	'g'
    '72'	:	'h'
    '73'	:	'i'
    '74'	:	'j'
    '75'	:	'k'
    '76'	:	'l'
    '77'	:	'm'
    '78'	:	'n'
    '79'	:	'o'
    '80'	:	'p'
    '81'	:	'q'
    '82'	:	'r'
    '83'	:	's'
    '84'	:	't'
    '85'	:	'u'
    '86'	:	'v'
    '87'	:	'w'
    '88'	:	'x'
    '89'	:	'y'
    '90'	:	'z'
    '91'	:	'left_window_key'
    '92'	:	'right_window_key'
    '93'	:	'select_key'
    '96'	:	'numpad_0'
    '97'	:	'numpad_1'
    '98'	:	'numpad_2'
    '99'	:	'numpad_3'
    '100'	:	'numpad_4'
    '101'	:	'numpad_5'
    '102'	:	'numpad_6'
    '103'	:	'numpad_7'
    '104'	:	'numpad_8'
    '105'	:	'numpad_9'
    '106'	:	'multiply'
    '107'	:	'add'
    '109'	:	'subtract'
    '110'	:	'decimal_point'
    '111'	:	'divide'
    '112'	:	'f1'
    '113'	:	'f2'
    '114'	:	'f3'
    '115'	:	'f4'
    '116'	:	'f5'
    '117'	:	'f6'
    '118'	:	'f7'
    '119'	:	'f8'
    '120'	:	'f9'
    '121'	:	'f10'
    '122'	:	'f11'
    '123'	:	'f12'
    '144'	:	'num_lock'
    '145'	:	'scroll_lock'
    '186'	:	'semicolon'
    '187'	:	'equal_sign'
    '188'	:	'comma'
    '189'	:	'dash'
    '190'	:	'period'
    '191'	:	'slash'
    '192'	:	'grave_accent'
    '219'	:	'open_bracket'
    '220'	:	'backslash'
    '221'	:	'close_bracket'
    '222'	:	'single_quote'

  KEYNAMES_CODES = _.invert KEYCODES_NAMES

  class KeyState

    constructor: (@keyName, @isDown = false, @shift = false, @ctrl = false, @alt = false) ->
      Object.defineProperties this,
        keyCode:
          get: () -> KEYNAMES_CODES[@keyName]
        isUp:
          get: () -> !@isDown
          set: (value) -> @isDown = !value; return


  class KeyStates
    constructor: () ->
      @keyStates = {}

    byKeyName: (keyName) -> @keyStates[keyName] ?= new KeyState(keyName)

    byKeyCode: (keyCode) -> @keyStates[KEYCODES_NAMES[keyCode]]

    clear: () -> @keyStates = {}; return

  class KeyboardListener extends Component

    constructor: () ->
      super
      @keyStates = new KeyStates()
      @updateContext = null
      @updateContextExt = {keyboard: @keyStates}

      _.bindAll this, 'onKeyDown', 'onKeyUp'

    added: (parent) ->
      super
      @addListeners parent
      return

    removed: (parent) ->
      super
      @removeListeners parent
      @keyStates.clear()
      @updateContext = null
      return

    update: (context) ->
      @updateContext ?= _.extend(Object.create context, @updateContextExt)
      super @updateContext
      return

    addListeners: (component) ->
      if not (element = component.element)? then throw new Error 'component does not have an element to listen for events on.'

      element.addEventListener 'keyup', @onKeyUp
      element.addEventListener 'keydown', @onKeyDown
      return

    removeListeners: (component) ->
      if (element = component.element)?
        element.removeEventListener 'keydown', @onKeyDown
        element.removeEventListener 'keyup', @onKeyUp
      return

    onKeyDown: (event) ->
      keyCode = event.keyCode || event.which
      keyState = @keyStates.byKeyCode(keyCode)
      keyState.isDown = yes
      keyState.shift = event.shiftKey
      keyState.ctrl = event.ctrlKey
      keyState.alt = event.altKey

      log.debug "KeyCode #{keyCode} is down"
      return

    onKeyUp: (event) ->
      keyCode = event.keyCode || event.which
      @keyStates.byKeyCode(keyCode).isUp = yes

      log.debug "KeyCode #{keyCode} is up"
      return
