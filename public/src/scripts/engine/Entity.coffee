define ['underscore', 'ComponentCollection'], (_, ComponentCollection) ->

  class Entity extends ComponentCollection

    constructor: (args) ->
      {@transformation} = args
      @transformation = _.defaults(@transformation or {}, {translation:[0,0], rotation:0.0})
      super

    update: (args) ->
      c.update(args) for cn, c of @components if not _.isEmpty @components
      return

    render: (args) ->
      c.render(args) for cn, c of @components if not _.isEmpty @components
      return