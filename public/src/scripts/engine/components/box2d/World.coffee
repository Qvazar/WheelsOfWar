define ['Box2D', 'underscore', '../Component'], (Box2D, _, Component) ->

  class WorldComponent extends Component

    constructor: (args) ->
      {@gravity} = args if args?
      @gravity ?= 10

      @world = @createWorld()
      @updateContextExt =
        box2d:
          world: @world
      @updateContext = null
      super

    removed: (parent) ->
      @updateContext = null

    update: (context) ->
      @updateContext ?= _.extend Object.create(context), @updateContextExt
      super @updateContext

    createWorld: () ->
      debugger;