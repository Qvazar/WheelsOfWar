define ['../../log', '../../css', '../../util', './Html'], (log, css, util, HtmlComponent) ->

  cssClass = 'canvas-component'

#  css.createRule ".#{cssClass} { position:absolute; top:0; left:0 }"

  class CanvasComponent extends HtmlComponent

    constructor: (args) ->
      super

      {@clearOnRender} = args if args?
      @clearOnRender ?= false
      @canvasContext = @element.getContext?('2d') or throw new Error 'canvas 2d context is not supported.'

      @renderContextExt =
        canvas:
          draw: @drawOnCanvas.bind(this)

      @renderContext = null

    createElement: () ->
      super('canvas', cssClass)
      @element.width = util.toPixels @width
      @element.height = util.toPixels @height

    clearCanvas: () ->
      @canvasContext.clearRect 0, 0, @element.width, @element.height

    render: (context) ->
      @clearCanvas() if @clearOnRender

      @renderContext ?= _.extend Object.create(context), @renderContextExt

      super @renderContext
      return

    drawOnCanvas = (drawFn) =>
      @canvasContext.save()
      # Move to the center of the canvas and offset by ½ a pixel to draw "on pixels" not between them!
      @canvasContext.translate @width / 2 - .5, @height / 2 - .5
      try
        drawFn @canvasContext
      finally
        @canvasContext.restore()

