define ['./log'], (log) ->

  createSheet = () ->
    head = document.head || document.getElementsByTagName('head')[0]
    style = document.createElement 'style'

    head.appendChild style
    return style.sheet

  vendorProperty = (() ->
    propMap = {}
    vendors = ['ms', 'o', 'webkit', 'moz']

    return (propName, element = document.createElement('div')) ->
      vPropName = propMap[propName]
      if vPropName? then return vPropName

      if element.style[propName]? then return propMap[propName] = propName

      capitalizedPropName = propName.charAt(0).toUpperCase() + propName.substring(1)

      for v in vendors
        vPropName = v + capitalizedPropName
        if element.style[vPropName]?
          log.info 'css: ' + propName + ' maps to ' + vPropName + '.'
          return propMap[propName] = vPropName

      return null
  )()

  sheet = null
  transformStringArray = null;
  rotationLimit = Math.PI * 2

  return {
    createRule: (rule) ->
      sheet ?= createSheet()
      sheet.insertRule rule, 0
      return

    transform: (element, x, y, rot, scale) ->
      transformStringArray ?= if vendorProperty('perspective', element)?
        ['translate3d(', 'x', 'px, ', 'y', 'px, 0) rotate3d(0, 0, ', 'r', 'rad) scale(', 's', ')']
      else
        ['translate(', 'x', 'px, ', 'y', 'px) rotate(', 'r', 'rad) scale(', 's', ')']

      transformStringArray[1] = x
      transformStringArray[3] = y
      transformStringArray[5] = rot % rotationLimit
      transformStringArray[7] = scale

      element.style[vendorProperty('transform', element)] = transformStringArray.join('')
      return

    vendorProperty
  }