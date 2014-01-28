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
      @canvasContext.translate @width / 2 - .5, @height / 2 - .5
      @renderContextExt = {@canvasContext}
      @renderContext = null

      @draw = (drawFn) =>
        @canvasContext.save()
        try
          drawFn @canvasContext
        finally
          @canvasContext.restore()

    createElement: () ->
      super('canvas', cssClass)
      @element.width = @width
      @element.height = @height

    clearCanvas: () ->
      @element.width = @width

    render: (context) ->
      @clearCanvas() if @clearOnRender

      if not @renderContext?.prototype is context
        @renderContext = Object.create(context)
        @renderContext = _.extend(@renderContext, @renderContextExt)

      super @renderContext
      return
