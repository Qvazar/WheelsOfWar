define ['../../log', '../../util', '../../css', '../ComponentCollection'],
  (log, util, css, ComponentCollection) ->

    cssClass = 'viewport'
    anchorCssClass = 'html-component-anchor'

    # Create sprite stylesheet
#    css.createRule ".#{cssClass} { position:relative; top: 0; left:0; }"
    css.createRule ".#{anchorCssClass} { display:block; position:absolute; top:50%; left:50%; width:1px; height:1px; overflow:visible; }"

    class Viewport extends ComponentCollection

      constructor: (args) ->
        super
        @element = @createElement()
        @contextExt = {element: @element.firstChild}
        @updateContext = null
        @renderContext = null

      createElement: () ->
        element = document.createElement 'div'
        element.className = cssClass
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

        @updateContext ?= _.extend Object.create(context), @contextExt

        c.update?(@updateContext) for cn, c of @components
        return

      render: (context) ->
        @renderContext ?= _.extend Object.create(context), @contextExt

        c.render?(@renderContext) for cn, c of @components
        return