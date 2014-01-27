define ['/log', '/css', 'HtmlElement'], (log, css, HtmlElementComponent) ->

  cssClass = 'canvas-component'

  # Create sprite stylesheet
  css.createRule ".#{cssClass} { position:absolute; top:0; left:0 }"

  class CanvasComponent extends HtmlElementComponent

    constructor: (args) ->
      super

      {@clearOnRender} = args if args?
      @clearOnRender ?= false
      @canvasContext = @element.getContext?('2d') or throw new Error 'canvas 2d context is not supported.'
      @canvasContext.translate @width / 2, @height / 2

      @draw = (drawFn) =>
        @canvasContext.save()
        try {
          drawFn @canvasContext
        } finally {
          @canvasContext.restore()
        }

    createElement: () ->
      super('canvas', cssClass)
      @element.width = @width
      @element.height = @height

    clearCanvas: () ->
      @element.width = @width

    update: (context) ->
      context = Object.create(context)
      context.canvasContext = @canvasContext
      super context
      return


    render: (context) ->
      @clearCanvas() if @clearOnRender

      context = Object.create(context)
      context.draw = @draw
      super context
      return
