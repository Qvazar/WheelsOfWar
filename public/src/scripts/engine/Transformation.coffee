define [], () ->

  class Transformation
    constructor: (args) ->
      {@x, @y, @rotation, @scale} = args if args?
      @x ?= 0
      @y ?= 0
      @rotation ?= 0
      @scale ?= 1.0
