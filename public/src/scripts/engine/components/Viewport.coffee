define ['../log', '../util', '../css', './ComponentCollection'],
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

      update: (context) ->
        if @element.parentNode isnt context.element
          context.element?.appendChild @element

        if not @updateContext?
          @updateContext = Object.create(context)
          @updateContext = _.extend(@updateContext, @contextExt)

        c.update(args) for cn, c of @components
        return

      render: (context) ->
        if not @renderContext?
          @renderContext = Object.create(context)
          @renderContext = _.extend(@renderContext, @contextExt)

        c.render(args) for cn, c of @components
        return