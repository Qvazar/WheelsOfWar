define ['underscore', '../log', '../css', '../util', '../Transformation', './Component'], (_, log, css, util, Transformation, Component) ->

  cssClass = 'html-component'
  anchorCssClass = 'html-component-anchor'

  # Create sprite stylesheet
  css.createRule ".#{cssClass} { display:block; position:absolute; top:0; left:0; }"
  #css.createRule ".#{anchorCssClass} { display:block; position:absolute; top:50%; left:50%; width:1px; height:1px; overflow:visible; }"

  class HtmlElementComponent extends Component

    constructor: (args) ->
      super
      {@width, @height, @cssClasses} = args if args?
      @transformation = new Transformation(args?.transformation)
      @_oldTransformation = new Transformation(@transformation)
      @_deltaTransformation = new Transformation()
      @width ?= 1
      @height ?= 1
      @element = @createElement()
      @contextExt = {element: @element.firstChild}
      @updateContext = null
      @renderContext = null

    createElement: (tagName = 'div', cssClasses...) ->
      element = document.createElement(tagName)
      pxWidth = util.toPixels(@width)
      pxHeight = util.toPixels(@height)

      element.className = [cssClass].concat(@cssClasses).concat(cssClasses).join(' ')
      element.style.width = pxWidth  + 'px'
      element.style.height = pxHeight + 'px'
      element.style.top = (pxWidth / 2 * -1) + 'px'
      element.style.left = (pxHeight / 2 * -1) + 'px'
      element.innerHTML = "<div class=\"#{anchorCssClass}\"></div>"

      return element

    removed: (parent) ->
      @element.parentNode?.removeChild @element
      @updateContext = null
      @renderContext = null
      super
      return

    update: (context) ->
      if @element.parentNode isnt context.element
        context.element?.appendChild @element

      newTransformation = @transformation
      oldTransformation = @_oldTransformation
      deltaTransformation = @_deltaTransformation

      deltaTransformation.x = newTransformation.x - oldTransformation.x
      deltaTransformation.y = newTransformation.y - oldTransformation.y
      deltaTransformation.rotation = newTransformation.rotation - oldTransformation.rotation
      deltaTransformation.scale = newTransformation.scale - oldTransformation.scale

      oldTransformation.x = newTransformation.x
      oldTransformation.y = newTransformation.y
      oldTransformation.rotation = newTransformation.rotation
      oldTransformation.scale = newTransformation.scale

      if not @updateContext?
        @updateContext = Object.create(context)
        @updateContext = _.extend(@updateContext, @contextExt)

      super @updateContext
      return

    render: (context) ->
      deltaTrans = @_deltaTransformation
      targetTrans = @transformation
      invAlpha = 1.0 - context.alpha
      x = util.toPixels(targetTrans.x - (deltaTrans.x * invAlpha))
      y = util.toPixels(targetTrans.y - (deltaTrans.y * invAlpha))
      r = targetTrans.rotation - (deltaTrans.rotation * invAlpha)
      s = targetTrans.scale - (deltaTrans.scale * invAlpha)

      css.transform @element, x, y, r, s

      if not @renderContext?
        @renderContext = Object.create(context)
        @renderContext = _.extend(@renderContext, @contextExt)

      super @renderContext
      return
