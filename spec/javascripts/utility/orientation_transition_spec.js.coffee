#= require spec_helper
#= require application

OrientationTransition = Emberspective.OrientationTransition
SpatialTransform = Emberspective.SpatialTransform

describe "OrientationTransition", ->
  before = null
  after = null

  beforeEach ->
    before = SpatialTransform.create
      translation: { x: 100, y: 200, z: 300 }
      rotation: { x: 1, y: 2, z: 3 }
      scale: 1

    after = before.clone()
      #translation: { x: 400, y: 500, z: 600 }
      #rotation: { x: 4, y: 5, z: 6 }
      #scale: 0.5

  it 'zooming transitions', ->
    ot = OrientationTransition.between(before, after)
    ot.transform.should.deep.equal before.inverse()
    ot.beforeFocus.should.deep.equal before
    ot.afterFocus.should.deep.equal after

