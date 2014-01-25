define [], () ->

  class Entity

    constructor: (@position, @components) ->

    update: (updateArgs) ->
      component.update(updateArgs) for component in @components
      return

    render: (renderArgs) ->
      context.translate @position[0], @position[1]

      for component in @components
        context.save()
        component.render(renderArgs)
        context.restore()
      return