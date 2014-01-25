define ['log'], (log) ->

  animationFrameTime = 1000 / 20 # time between frames
  defaultAnimationName = 'idle'

  class Sprite

    constructor: (@spriteDef, @transformation = {translation:[0,0], rotation:0.0}) ->
      @currentAnimation = defaultAnimationName
      @currentFrameIndex = 0
      @currentFrameStartTime = null

    render: (args) ->
      if not @currentFrameStartTime? then @currentFrameStartTime = args.time

      if (framesToPush = Math.floor((args.time - @currentFrameStartTime) / animationFrameTime)) > 0
        anim = @spriteDef.animations[@currentAnimation];
        @currentFrameIndex = (@currentFrameIndex + framesToPush) % anim.keys.length
        @currentFrameStartTime = args.time

        if @currentFrameIndex is 0 and not anim.looping
          @currentAnimation = defaultAnimationName

      currentImage = @spriteDef.animations[@currentAnimation].frames[@currentFrameIndex]
      spriteMap = @spriteDef.spritesheet.map[currentImage]
      context = args.context

      rotation = @transformation.rotation
      translation = @transformation.translation
      context.rotate rotation
      context.translate translation[0], translation[1]

      context.drawImage(
        @spriteDef.spritesheet.image
        spriteMap.x, spriteMap.y, spriteMap.w, spriteMap.h,
        spriteMap.w * -.5, spriteMap.h * -.5
      )
      return

    animate: (animationName) ->
      if @spriteDef.animations[animationName]?
        @currentAnimation = animationName
        @currentFrameIndex = 0
        @currentFrameStartTime = Date.now()
      else
        log.warn 'No animation found with name ' + animationName + '.'

      return