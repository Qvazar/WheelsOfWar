define [], () ->

  class Transformation
    constructor: (args) ->
      {@translation, @rotation, @scale} = args if args?