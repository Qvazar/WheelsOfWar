define ['../log', '../util', '../css', '/Html'],
  (log, util, css, Html) ->

    rootNodeCssClass = 'html-component-root-node'

    # Create sprite stylesheet
    css.createRule ".#{rootNodeCssClass} { display:block; position:absolute; top:50%; left:50%; }"

    class Viewport extends Html

      constructor: (args) ->
        @_rootElement = null
        super

      createElement: () ->
        super
        @_rootElement = document.createElement 'div'
        @_rootElement.className = rootNodeCssClass
        @element.appendChild @_rootElement

      update: (context) ->
