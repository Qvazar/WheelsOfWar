define ['require', 'lazy', '../log', 'components/Sprite'], (require, lazy, log, Sprite) ->

  class SpriteLoader

    constructor: () ->
      @spriteDefs = {}

    loadSprites: (spritesheetImageUrl, spritesheetMapUrl, spriteDefUrls, callback) ->
      jsonRequires = lazy([spritesheetMapUrl, spriteDefUrls]).flatten().map((url) -> 'json!' + url).toArray()

      require(
        ['image!' + spritesheetImageUrl].concat(jsonRequires)
        (spritesheetImage, spritesheetMap, spriteDefs...) ->
          spritesheet =
            image: spritesheetImage,
            map: spritesheetMap

          spriteDefs = lazy(spriteDefs).flatten()
          spriteDefs.each (spriteDef) ->
            spriteDef.spritesheet = spritesheet
            @spriteDefs[spriteDef.name] = spriteDef
            return

          if callback? then callback(null, spriteDefs.toArray())
          return
        (error) ->
          if callback? then callback(error)
          return
      )
      return

    createSprite: (spriteDefName) ->
      if (spriteDef = @spriteDefs[spriteDefName])?
        return new Sprite(spriteDef)
      else
        log.warn 'No sprite definition known with name ' + spriteDefName + '. Has it been loaded?'
        return