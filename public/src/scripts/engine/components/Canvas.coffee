define ['/log', '/css', 'HtmlElement'], (log, css, HtmlElementComponent) ->

  cssClass = 'canvas-component'

  # Create sprite stylesheet
  css.createRule ".#{cssClass} { position:absolute; top:0; left:0 }"

  class CanvasComponent extends HtmlElementComponent

    constructor: (args) ->
      super
      @context = @element.getContext?('2d') or throw new Error 'canvas 2d context is not supported.'

    createElement: () ->
      canvas = super('canvas', cssClass)
      canvas.width = @width
      canvas.height = @height

    update: (args) ->


    render: (args) ->
