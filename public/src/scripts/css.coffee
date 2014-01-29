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

      if element.style[propName]? then return propMap[propName] = propName

      for v in vendors
        vPropName = v + propName
        if element.style[vPropName] then return propMap[propName] = vPropName

      return null
  )()

  transformStringArray = null;

  return {
    createRule: (rule) ->
      sheet ?= createSheet()
      sheet.insertRule rule, 0
      return

    transform: (element, x, y, r) ->
      transformStringArray ?= if vendorProperty(element, 'perspective')? then ['translate3d(', 'x', 'px,', 'y', 'px,0) rotate(', 'r', 'rad)'] else
        ['translate(', 'x', 'px,', 'y', 'px) rotate(', 'r', 'rad)']

      transformStringArray[1] = x
      transformStringArray[3] = y
      transformStringArray[5] = r

      element.style[vendorProperty('transform')] = transformStringArray.join('')
  }