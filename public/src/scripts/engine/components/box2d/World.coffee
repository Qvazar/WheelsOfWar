define ['../Component'], (Component) ->

  class WorldComponent extends Component

    constructor: (args) ->
      {@gravity} = args if args?
      super

    update: (context) ->
