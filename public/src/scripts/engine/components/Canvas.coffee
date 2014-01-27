define ['/log', '/css'], (log, css) ->

  canvasCssClass = 'canvas-component'

  # Create sprite stylesheet
  css.createRule ".#{canvasCssClass} { position:absolute; top:0; left:0 }"

  createCanvasAndContext: (width, height) ->
    canvas = document.createElement('canvas')
    canvas.width = width
    canvas.height = height
    canvas.className = canvasCssClass
    canvas.style.width = width + 'px'
    canvas.style.height = height + 'px'

    context = canvas.getContext?('2d') or throw new Error 'canvas 2d context is not supported.'

    return {canvas, context}

  class CanvasComponent

    constructor: (args) ->
      {@width, @height} = args if args?
      @width ?= 64
      @height ?= 64
      super

    update: (args) ->

    render: (args) ->
