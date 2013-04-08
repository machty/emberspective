#= require spec_helper
#= require application

GraphController = Emberspective.GraphController
GraphNodesController = Emberspective.GraphNodesController
run = Ember.run

describe "GraphNodesController", ->
  controller = null
  beforeEach ->
    run ->
      controller = Emberspective.GraphNodesController.create
        content: SAMPLE_EMBERSPECTIVE_TREE_FLATTENED

  afterEach ->
    run ->
      controller.destroy() if controller
      controller = null

  it 'is an Ember.ArrayController', ->
    #Ember.Controller.detect(GraphNodesController).should.be.ok
  

describe "GraphController", ->
  controller = null

  createController = (tree = SAMPLE_EMBERSPECTIVE_TREE) ->
    controller = Emberspective.GraphController.create
      tree: tree

  afterEach ->
    run ->
      controller.destroy() if controller
      controller = null

  it 'is an Ember.Controller', ->
    Ember.Controller.detect(GraphController).should.be.ok

  describe '`nodes` computed property', ->
    beforeEach ->
      run ->
        createController()

    it 'returns a flattened array of all nodes', ->
      names = controller.get('nodes').map (node) -> node.get('name')
      names.should.deep.equal ["Ember", "Perf", "Router", "Transitions", "View"]

  
