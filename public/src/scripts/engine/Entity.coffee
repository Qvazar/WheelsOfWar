define [], () ->

  class Entity

    constructor: (@transformation = {translation: [0,0], rotation: 0.0}, @components = {}) ->

    update: (updateArgs) ->
      component.update(updateArgs) for component in @components when component.update?
      return

    render: (renderArgs) ->
      translation = @transformation.translation
      rotation = @transformation.rotation
      context.translate translation[0], translation[1]
      context.rotate rotation

      for componentName, component of @components when component.render?
        context.save()
        component.render(renderArgs)
        context.restore()
      return