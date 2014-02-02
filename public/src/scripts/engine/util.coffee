define [], () ->

  pixelsPerMeter: 64

  toPixels: (meters) ->
    if _.isArray(meters)
      pixels = (toPixels meter for meter in meters)
      return pixels
    else return meters * @pixelsPerMeter

  toMeters: (pixels) ->
    if _.isArray(pixels)
      meters = (toMeters pixel for pixel in pixels)
      return meters
    else return pixels * (1 / @pixelsPerMeter)

