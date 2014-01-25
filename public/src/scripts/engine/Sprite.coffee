define ['log'], (log) ->

  animationSpeed = 10 # updates per second
  defaultAnimationName = 'idle'

  class Sprite

    constructor: (@spriteDef) ->
      @currentAnimation = defaultAnimationName
      @currentAnimationIndex = 0
      @currentAnimStartTime = Date.now()

    update: (updateArgs) ->
      if updateArgs.time - @currentAnimStartTime % animationSpeed is 0
        anim = @spriteDef.animations[@currentAnimation];
        @currentAnimationIndex = (@currentAnimationIndex + 1) % anim.keys.length

        if @currentAnimationIndex is 0 and anim.indefinite is off
          @currentAnimation = defaultAnimationName
      return

    render: (renderArgs) ->
      currentImage = @spriteDef.animations[@currentAnimation].frames[@currentAnimationIndex]
      spriteMap = @spriteDef.spritesheet.map[currentImage]

      renderArgs.context.drawImage(
        @spriteDef.spritesheet.image
        spriteMap.x, spriteMap.y, spriteMap.w, spriteMap.h,
        spriteMap.w * -.5, spriteMap.h * -.5
      )
      return

    animate: (animationName) ->
      if @spriteDef.animations[animationName]?
        @currentAnimation = animationName
        @currentAnimationIndex = 0
        @currentAnimStartTime = Date.now()
      else
        log.warn 'No animation found with name ' + animationName + '.'

      return