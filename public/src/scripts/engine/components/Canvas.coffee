define ['/log', '/css', 'HtmlElement'], (log, css, HtmlElementComponent) ->

  cssClass = 'canvas-component'

  css.createRule ".#{cssClass} { position:absolute; top:0; left:0 }"

  class CanvasComponent extends HtmlElementComponent

    constructor: (args) ->
      super

      {@clearOnRender} = args if args?
      @clearOnRender ?= false
      @canvasContext = @element.getContext?('2d') or throw new Error 'canvas 2d context is not supported.'
      @canvasContext.translate @width / 2 - .5, @height / 2 - .5

      draw = (drawFn) =>
        @canvasContext.save()
        try
          drawFn @canvasContext
        finally
          @canvasContext.restore()

      @renderContextExt = {@canvasContext, draw}
      @renderContext = null

    createElement: () ->
      super('canvas', cssClass)
      @element.width = @width
      @element.height = @height

    clearCanvas: () ->
      @element.width = @width

    render: (context) ->
      @clearCanvas() if @clearOnRender

      if @renderContext?.prototype isnt context
        @renderContext = Object.create(context)
        @renderContext = _.extend(@renderContext, @renderContextExt)

      super @renderContext
      return
