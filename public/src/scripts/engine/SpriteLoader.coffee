define ['require', 'underscore', '../log', 'components/Sprite'], (require, _, log, Sprite) ->

  class SpriteLoader

    constructor: () ->
      @spriteDefs = {}

    loadSprites: (spritesheetImageUrl, spritesheetMapUrl, spriteDefUrls, callback) ->
      jsonRequires = _.map(_.flatten([spritesheetMapUrl, spriteDefUrls]), (url) -> 'json!' + url)

      require(
        ['image!' + spritesheetImageUrl].concat(jsonRequires)
        (spritesheetImage, spritesheetMap, spriteDefs...) ->
          spritesheet =
            image: spritesheetImage,
            map: spritesheetMap

          spriteDefs = _.flatten(spriteDefs)
          spriteDefs.each (spriteDef) ->
            spriteDef.spritesheet = spritesheet
            @spriteDefs[spriteDef.name] = spriteDef
            return

          if callback? then callback(null, spriteDefs)
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