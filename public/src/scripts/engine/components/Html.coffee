define ['underscore', '../log', '../css', '../util', './Component'], (_, log, css, util, Component) ->

  cssClass = 'html-component'

  # Create sprite stylesheet
  css.createRule ".#{cssClass} { position:absolute; top:0; left:0 }"

  class HtmlElementComponent extends Component

    constructor: (args) ->
      super
      {@width, @height, @cssClasses, @transformation} = args if args?
      @transformation = _.defaults(@transformation or {}, {translation:[0,0], rotation:0.0, scale: 1.0})
      @_oldTransformation = {translation:[@transformation.translation[0],@transformation.translation[1]], rotation:@transformation.rotation, scale: @transformation.scale}
      @_deltaTransformation = {translation:[0,0], rotation:0.0, scale: 0.0}
      @width ?= 1
      @height ?= 1
      @element = @createElement()
      @contextExt = {@element}
      @updateContext = null
      @renderContext = null

    createElement: (tagName = 'div', cssClasses...) ->
      element = document.createElement(tagName)
      element.className = [cssClass].concat(@cssClasses).concat(cssClasses).join(' ')
      element.style.width = util.toPixels(@width)  + 'px'
      element.style.height = util.toPixels(@height) + 'px'
      return element

    update: (context) ->
      if @updateContext?.prototype isnt context
        @updateContext = Object.create(context)
        @updateContext = _.extend(@updateContext, @contextExt)

      newTransformation = @transformation
      oldTransformation = @_oldTransformation
      deltaTransformation = @_deltaTransformation
      deltaTransformation.translation[0] = newTransformation.translation[0] - oldTransformation.translation[0]
      deltaTransformation.translation[1] = newTransformation.translation[1] - oldTransformation.translation[1]
      deltaTransformation.rotation = newTransformation.rotation - oldTransformation.rotation
      deltaTransformation.scale = newTransformation.scale - oldTransformation.scale

      oldTransformation.translation[0] = newTransformation.translation[0]
      oldTransformation.translation[1] = newTransformation.translation[1]
      oldTransformation.rotation = newTransformation.rotation
      oldTransformation.scale = newTransformation.scale

      super @updateContext
      return

    render: (context) ->
      deltaTrans = @_deltaTransformation
      targetTrans = @transformation
      invAlpha = 1.0 - context.alpha
      x = util.toPixels((targetTrans.translation[0] - (deltaTrans.translation[0] * invAlpha)) - @width/2)
      y = util.toPixels((targetTrans.translation[1] - (deltaTrans.translation[1] * invAlpha)) - @width/2)
      r = targetTrans.rotation - (deltaTrans.rotation * invAlpha)
      s = targetTrans.scale - (deltaTrans.scale * invAlpha)

      css.transform @element, x, y, r, s

      if @renderContext?.prototype isnt context
        @renderContext = Object.create(context)
        @renderContext = _.extend(@renderContext, @contextExt)

      super @renderContext
      return
