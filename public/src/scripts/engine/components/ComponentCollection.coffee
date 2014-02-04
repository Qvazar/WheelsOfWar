define [], () ->

  class ComponentCollection

    constructor: (args) ->
      {@components} = args if args?
      @components ?= {}
      c.parent = this for cn, c of @components

    add: (namesAndComponents) ->
      for name, component of namesAndComponents
        oldName = component.name
        component.parent?.remove?(oldName)

        @components[name] = component
        component.name = name
        component.parent = this
        component.added?(this)

      return this

    remove: (names...) ->
      for name in names
        c = @get(name)
        delete @components[name]
        c.parent = c.name = null
        c.removed?(this)

      return this

    get: (name) ->
      return @components[name]

    each: (fn) ->
      fn(c) for cn, c of @components
      return this
