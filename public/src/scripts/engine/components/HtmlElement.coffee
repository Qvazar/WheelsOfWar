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

    createElement: (tagName = 'div', cssClasses...) ->
      element = document.createElement(tagName)
      element.className = [defaultCssClass].concat(cssClasses).join(' ')
      element.style.width = @width + 'px'
      element.style.height = @height + 'px'
      return element

    update: (context) ->
      context = Object.create(context)
      context.element = @element
      super context
      return

    render: (context) ->
      css.transform @element, @transformation

      context = Object.create(context)
      context.element = @element
      super context
      return
