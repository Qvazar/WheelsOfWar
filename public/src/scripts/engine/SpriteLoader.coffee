define ['require', 'lazy', '../log', 'Sprite'], (require, lazy, log, Sprite) ->

  class SpriteLoader

    constructor: () ->
      @spriteDefs = {}

    loadSprites: (spritesheetImageUrl, spritesheetMapUrl, spriteDefUrls, callback) ->
      jsonRequires = lazy(arguments[1...2]).flatten().map((url) -> 'json!' + url).toArray()

      require ['image!' + spritesheetImageUrl].concat(jsonRequires), (spritesheetImage, spritesheetMap, spriteDefs) ->
        spritesheet =
          image: spritesheetImage,
          map: spritesheetMap

        lazy(arguments[2..]).each (spriteDef) ->
          spriteDef.spritesheet = spritesheet
          @spriteDefs[spriteDef.name] = spriteDef
          return

        if callback? then callback()
      return

    createSprite: (spriteName) ->
      if (spriteDef = @spriteDefs[spriteName])?
        return new Sprite(spriteDef)
      else
        log.warn 'No sprite definition known with name ' + spriteName + '. Has it been loaded?'
        return