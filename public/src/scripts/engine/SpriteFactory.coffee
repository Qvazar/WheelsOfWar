define ['require', 'underscore', '../log', 'components/Sprite'], (require, _, log, Sprite) ->

  class SpriteFactory

    constructor: () ->
      @spriteDefs = {}

    loadSprites: (args) ->
      {spritesheets, spritedefs, callback} = args if args?

      spritesheets ?= []
      spritedefs ?= []

      spritesheetImageRequires = _.map spritesheets, (url) -> 'image!' + url + '.png'
      spritesheetJsonRequires = _.map spritesheets, (url) -> 'json!' + url + '.json'
      spritedefRequires = _.map spritedefs, (url) -> 'json!' + url

      require(
        spritesheetImageRequires.concat(spritesheetJsonRequires, spritedefRequires)
        (args...) ->
          spritesheetCount = spritesheets.length
          spritedefCount = spritedefs.length

          spritesheetImages = args[0...spritesheetCount]
          spritesheetMaps = args[spritesheetCount...-spritedefCount]
          spritedefs = args[-spritedefCount]
          
          callback() if callback?
        (error) ->
          callback(error) if callback?
      )

    loadSprites: (spritesheetImageUrls, spritesheetMapUrls, spriteDefUrls, callback) ->
      imageRequires = _.chain([spritesheetImageUrls]).flatten().map (url) -> 'image!' + url
      jsonRequires = _.chain([spritesheetMapUrls, spriteDefUrls]).flatten().map (url) -> 'json!' + url

      require(
        imageRequires.concat(jsonRequires),
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
          if callback? then callback error
          return
      )
      return

    createSprite: (spriteDefName) ->
      if (spriteDef = @spriteDefs[spriteDefName])?
        return new Sprite(spriteDef)
      else
        log.warn 'No sprite definition known with name ' + spriteDefName + '. Has it been loaded?'
        return