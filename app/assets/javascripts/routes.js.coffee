
# Draw out our routes
Emberspective.Router.map ->
  @resource 'graph', path: '/', ->
    @route 'show', path: '/:stub'

Emberspective.ApplicationRoute = Ember.Route.extend
  events: 
    routeTo: ->
      @transitionTo.apply(@, arguments)

Emberspective.GraphRoute = Ember.Route.extend
  model: -> Emberspective.GraphNode.findAll()
  setupController: (controller, nodes) -> 
    @_super(controller, nodes)

    # This sets the layout for the graph.
    controller.controllerForNode(nodes[0]).layoutNodes()

Emberspective.GraphIndexRoute = Ember.Route.extend
  # Redirect to graph root.
  redirect: -> @transitionTo 'graph.show', @modelFor('graph')[0]

Emberspective.GraphShowRoute = Ember.Route.extend
  model: (params) ->
    @modelFor('graph').find (node) -> node.get('stub') == params.stub

  # By overriding `setup` (vs. just setupController or renderTemplates),
  # we override ALL the default logic for rendering and controller resolution,
  # because all we want to do here is send the right information to the
  # GraphController about which node was selected so that its views know
  # how to re-render themselves to focus the graph on this node.
  # NOTE: depending on how big GraphController grows, it may be wise
  # to refactor and use a more default GraphShowRoute (which would
  # interact with the GraphController if and when it needs to).
  setup: (node) ->
    @controllerFor('graph').set 'currentNode', node

  serialize: (object) -> 
    { stub: object.get('stub') }
