define ['underscore', '/log', '/css', 'Component'], (_, log, css, Component) ->

  defaultCssClass = 'html-component'

  # Create sprite stylesheet
  css.createRule ".#{defaultCssClass} { position:absolute; top:0; left:0 }"

  class HtmlElementComponent extends Component

    constructor: (args) ->
      super
      {@width, @height} = args if args?
      @width ?= 64
      @height ?= 64
      @element = @createElement()
      @contextExt = {@element}
      @updateContext = null
      @renderContext = null

    createElement: (tagName = 'div', cssClasses...) ->
      element = document.createElement(tagName)
      element.className = [defaultCssClass].concat(cssClasses).join(' ')
      element.style.width = @width + 'px'
      element.style.height = @height + 'px'
      return element

    update: (context) ->
      if @updateContext?.prototype isnt context
        @updateContext = Object.create(context)
        @updateContext = _.extend(@updateContext, @contextExt)

      super @updateContext
      return

    render: (context) ->
      x = @transformation.translation[0] - @width/2
      y = @transformation.translation[1] - @height/2
      r = @transformation.rotation
      css.transform @element, x, y, r

      if @renderContext?.prototype isnt context
        @renderContext = Object.create(context)
        @renderContext = _.extend(@renderContext, @contextExt)

      super @renderContext
      return
