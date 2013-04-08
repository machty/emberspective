#= require spec_helper
#= require application

GraphView = Emberspective.GraphView
GraphController = Emberspective.GraphController
graphView = null
run = Ember.run

sampleSnapshotTree =
  name: "Ember"
  description: "The JavaScript framework you know and love."
  children: [
    {
      name: "Perf"
      description: "Performance"
    },
    {
      name: "Router"
      description: "Router Stuff"
      children: [
        {
          name: "Transitions"
          description: "Transition Stuff"
        },
      ]
    },
    {
      name: "View"
      description: "View Stuff"
    },
  ]

describe "GraphView", ->
  afterEach ->
    run ->
      graphView.destroy() if graphView
    graphView = null

  describe "element layout", ->

    beforeEach -> Em.run -> graphView = GraphView.create().append()

    it 'should have a canvas element', ->
      $('.graph-view .graph-canvas-view').length.should.equal 1

    it 'should have CSS3 stylings by default', ->
      #graphEl = $('.graph-view')[0]
      #graphEl.style.position.should.equal "absolute"
      #graphEl.style.webkitTransform.should.equal "top left"
      #graphEl.style.webkitTransformStyle.should.equal "preserve-3d"

      #var rootStyles = {
          #position: "absolute",
          #transformOrigin: "top left",
          #transition: "all 0s ease-in-out",
          #transformStyle: "preserve-3d"
      #};
      
  describe "When linked to a controller with tree data", ->
    beforeEach -> 
      run -> 
        controller = Emberspective.GraphController.extend
          content: sampleSnapshotTree
        graphView = GraphView.create(controller: controller).append()

    it 'should render all tree elements as direct children of the canvas element', ->
      $sel = $('.graph-canvas-view > .graph-item-view')
      $sel.length.should.equal 5
      $sel.first().text.should.match /Ember/



      
    


    
