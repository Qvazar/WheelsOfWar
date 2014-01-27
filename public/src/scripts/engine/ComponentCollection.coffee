define [], () ->

  class ComponentCollection

    constructor: (args) ->
      {@components} = args
      @components ?= {}
      c.parent = this for cn, c of @components

    add: (name, component) ->
      component.parent?.remove?(component.name)

      @components[name] = component
      component.name = name
      component.parent = this

      return component

    remove: (name) ->
      c = @get(name)
      delete @components[name]
      c.parent = c.name = null
      return c

    get: (name) ->
      return @components[name]

    each: (fn) ->
      fn(c) for cn, c of @components
      return
