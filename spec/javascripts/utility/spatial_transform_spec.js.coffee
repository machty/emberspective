#= require spec_helper
#= require application

SpatialTransform = Emberspective.SpatialTransform

describe "SpatialTransform", ->

  describe 'constructor', ->
    it 'can be invoked without arguments and yield a SpatialTransform with default values', ->
      s = SpatialTransform.create()
      s.translation.should.deep.equal { x: 0, y: 0, z: 0 }
      s.rotation.should.deep.equal { x: 0, y: 0, z: 0 }
      s.scale.should.equal 1

  describe '#inverse', ->
    it 'should generate a separate SpatialTransform with inverted values', ->
      s = SpatialTransform.create
        translation: { x: 1, y: 2, z: 3 }
        rotation: { x: 4, y: 5, z: 6 }
        scale: 2
      i = s.inverse()
      i.translation.should.deep.equal { x: -1, y: -2, z: -3 }
      i.rotation.should.deep.equal { x: -4, y: -5, z: -6 }
      i.scale.should.equal 0.5
      (s != i).should.be.ok

  describe '#translate', ->
    it 'should generate a separate SpatialTransform with inverted values', ->
      s = SpatialTransform.create
        translation: { x: 1, y: 2, z: 3 }
        rotation: { x: 4, y: 5, z: 6 }
        scale: 2
      i = s.translate { x: 10, y: 20, z: 30 }
      i.translation.should.deep.equal { x: 11, y: 22, z: 33 }
      i.rotation.should.deep.equal { x: 4, y: 5, z: 6 }
      i.scale.should.equal 2
      (s != i).should.be.ok
      
    it 'should be able to handle single component translations', ->
      s = SpatialTransform.create
        translation: { x: 1, y: 2, z: 3 }
        rotation: { x: 4, y: 5, z: 6 }
        scale: 2
      i = s.translate { z: 100 }
      i.translation.should.deep.equal { x: 1, y:2, z:103 }

  describe 'chaining', ->
    it 'should be possible', ->
      s = SpatialTransform.create
        translation: { x: 1, y: 2, z: 3 }
        rotation: { x: 4, y: 5, z: 6 }
        scale: 2
      i = s.translate({ x: 10, y: 20, z: 30 }).inverse().translate({ x: -10, y: -20, z: -30 })
      i.translation.should.deep.equal { x: -21, y: -42, z: -63 }
      i.rotation.should.deep.equal { x: -4, y: -5, z: -6 }
      i.scale.should.equal 0.5
      (s != i).should.be.ok

  describe '#radiate', ->
    it 'accepts an angle and distance and returns a translated transform', ->
      s = SpatialTransform.create
        translation: { x: 10, y: 20, z: 30 }
        rotation: { x: 5, y: 5, z: 5 }
        scale: 2
      i = s.radiate(Math.PI, 100)

      # TODO: figure out how to use `approximately`. Probably need to upgrade.
      (Math.abs(i.translation.x + 90) < 0.001).should.be.ok
      (Math.abs(i.translation.y - 20) < 0.001).should.be.ok
