
Emberspective.GraphNodeController = Ember.ObjectController.extend
  needs: ['graph']
  active: false

  # Convenient properties that the views can bind their class attibutes to
  isLeaf: Ember.computed.empty('children')
  isRoot: Ember.computed.empty('parent')

  # A polar path is an array of (angle, distance) that
  # describes how to get this node from the center Ember.js node.
  #polarPath: ( ->
    #(@get('parentController.polarPath') || []).concat [@get('localPolarPath')]
  #).property('parentController.polarPath')

  transform: Emberspective.SpatialTransform.create()

  # Angle in which this node is shooting out from its parent. Ignored for root.
  angle: 0

  parentController: ( ->
    @get('controllers.graph').controllerForNode @get('content.parent')
  ).property()

  layoutNodes: ->
    graphController = @get('controllers.graph')
    
    transform = @get('transform')
    #isRoot = @get 'isRoot'
    angle = @get 'angle'

    children = @get('children')
    children.forEach (node, index, {length}) ->

      nc = graphController.controllerForNode(node)
      console.log Ember.guidFor(nc)

      rads = index / length * 2 * Math.PI + angle

      childTransform = transform.radiate(rads, 300).translate(z: -400)

      nc.setProperties
        transform: childTransform
        angle: rads
      nc.layoutNodes()

Emberspective.GraphController = Ember.ArrayController.extend
  _seenControllers: null

  # TODO: refactor this to use containers?
  controllerForNode: (node) ->
    return null unless node

    @_seenControllers ||= {}
    @_seenControllers[Ember.guidFor(node)] ||= Emberspective.GraphNodeController.create
      # Set target to the controller of the parent node or 
      # this controller if it's null.
      target: @controllerForNode(node.get('parent')) || @
      container: @get('container')
      content: node

  currentNode: null
  _previousNode: null

  currentNodeChanged: ( ->
    if @_previousNode
      @controllerForNode(@_previousNode).set 'active', false

    currentNode = @get('currentNode')
    @controllerForNode(currentNode).set 'active', true
    @_previousNode = currentNode

    # Now perform the transform to zoom in on the active node.




  ).observes('currentNode')

