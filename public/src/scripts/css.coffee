define [], () ->

  sheet = null

  createSheet = () ->
    head = document.head || document.getElementsByTagName('head')[0]
    style = document.createElement 'style'

    head.appendChild style
    return style.sheet

  vendorProperty = (() ->
    propMap = {}
    vendors = ['ms', 'O', 'Webkit', 'Moz']

    return (element, propName) ->
      vPropName = propMap[propName]
      if vPropName? then return vPropName

      if element.style[propName] then return propMap[propName] = propName


      for v in vendors
        vPropName = v + propName
        if element.style[vPropName] then return propMap[propName] = vPropName

      return null
  )()

  transformString = (() ->
    supports3d = null

    return (transformation) ->
      supports3d ?= (vendorProperty document.createElement('div'), 'perspective')?
      tr = transformation.translation
      r = transformation.rotation

      return "translate#{ if supports3d then '3d' else '' }(#{ tr[0] }px,#{ tr[0] }px#{ if supports3d then ',0' else '' }) rotate(#{ r }rad)"
  )()

  return {
    createRule: (rule) ->
      sheet ?= createSheet()
      sheet.insertRule rule, 0
      return

    transform: (element, transformation) ->
      element.style[vendorProperty('transform')] = transformString(transformation)
  }