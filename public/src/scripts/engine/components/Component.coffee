define ['underscore', './ComponentCollection'], (_, ComponentCollection) ->

  class Component extends ComponentCollection

    constructor: (args) ->
#      @absoluteTransformation = {translation:[0,0], rotation:0.0}
      @parent = null
      @name = null
      super

    added: (parent) ->

    removed: (parent) ->

    update: (args) ->
#      @absoluteTransformation.translation[0] = @transformation.translation[0]
#      @absoluteTransformation.translation[1] = @transformation.translation[1]
#      @absoluteTransformation.rotation = @transformation.rotation

#      if (parentAbsTrans = @parent?.absoluteTransformation)?
#        @absoluteTransformation.translation[0] += parentAbsTrans.translation[0]
#        @absoluteTransformation.translation[1] += parentAbsTrans.translation[1]
#        @absoluteTransformation.rotation += parentAbsTrans.rotation

      c.update?(args) for cn, c of @components
      return

    render: (args) ->
      c.render?(args) for cn, c of @components
      return

 #   getAbsoluteTransformation: (transformation = {translation:[0, 0], rotation: 0}) ->
 #     transformation = @parent?.getAbsoluteTransformation?(transformation) or (if (pTrans = @parent?.transformation)? then _.extend({}, pTrans)) or transformation
 #     transformation.translation[0] += @transformation.translation[0]
 #     transformation.translation[1] += @transformation.translation[1]
 #     transformation.rotation += @transformation.rotation
 #     return transformation
