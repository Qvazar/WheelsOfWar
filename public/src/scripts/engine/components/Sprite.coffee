define ['../../log', '../../css', 'Component'], (log, css, Component) ->

  animationFrameTime = 1000 / 20 # time between frames
  defaultAnimationName = 'idle'

  class Sprite extends Component

    constructor: (args) ->
      {@spriteDef} = args
      @currentAnimation = defaultAnimationName
      @currentFrameIndex = 0
      @currentFrameStartTime = null
      super

    render: (args) ->
      if not @canvas?
        spriteMap = @spriteDef.animations[@currentAnimation].frames[@currentFrameIndex]
        {@canvas, @context} = createCanvas(spriteMap.w, spriteMap.h)
        args.rootElement.appendChild @canvas

      if not @currentFrameStartTime? then @currentFrameStartTime = args.time

      if (framesToPush = Math.floor((args.time - @currentFrameStartTime) / animationFrameTime)) > 0
        anim = @spriteDef.animations[@currentAnimation]
        @currentFrameIndex = (@currentFrameIndex + framesToPush) % anim.keys.length
        @currentFrameStartTime = args.time

        if @currentFrameIndex is 0 and not anim.looping
          @currentAnimation = defaultAnimationName

      currentFrame = @spriteDef.animations[@currentAnimation].frames[@currentFrameIndex]
      spriteMap = @spriteDef.spritesheet.map[currentFrame]

      rotation = @transformation.rotation
      translation = args.toPixels @transformation.translation
      css.transform @canvas, translation

      args.useContext (context) =>
        context.rotate rotation
        context.translate translation[0], translation[1]

        context.drawImage(
          @spriteDef.spritesheet.image
          spriteMap.x, spriteMap.y, spriteMap.w, spriteMap.h,
          spriteMap.w * -.5, spriteMap.h * -.5
        )

      super

    animate: (animationName) ->
      if @spriteDef.animations[animationName]?
        @currentAnimation = animationName
        @currentFrameIndex = 0
        @currentFrameStartTime = Date.now()
      else
        log.warn 'No animation found with name ' + animationName + '.'

      return