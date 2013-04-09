# Want to use this for both calculating root and canvas zoom/rotation,
# but also for incrementally building up transforms from the root
# to leaf nodes.
Emberspective.SpatialTransform = Ember.CoreObject.extend
  translation: { x: 0, y: 0, z: 0 }
  rotation: { x: 0, y: 0, z: 0 }
  scale: 1

  clone: ->
    Emberspective.SpatialTransform.create 
      translation: @translation
      rotation: @rotation
      scale: @scale

  inverse: ->
    c = @clone()
    ct = c.translation
    ct = { x: -ct.x, y: -ct.y, z: -ct.z }
    c.translation = ct

    cr = c.rotation
    cr = { x: -cr.x, y: -cr.y, z: -cr.z }
    c.rotation = cr

    c.scale = 1 / c.scale
    c

  translate: (t) ->
    @_applyTo 'translation', t

  rotate: (t) ->
    @_applyTo 'rotation', t

  _applyTo: (prop, values) ->
    c = @clone()
    t = values
    ct = c[prop]
    ct = { x: ct.x, y: ct.y, z: ct.z }
    ct.x += t.x if t.x
    ct.y += t.y if t.y
    ct.z += t.z if t.z
    c[prop] = ct
    c

  radiate: (rads, distance) ->
    c = @clone()
    ct = c.translation
    ct = { x: ct.x + Math.cos(rads)*distance, y: ct.y + Math.sin(rads)*distance, z: ct.z }
    c.translation = ct
    c




