
config =
  width: 1024
  height: 768
  maxScale: 1
  minScale: 0
  perspective: 1000
  transitionDuration: 1000

f = (num) -> num.toFixed(3)

# Helper functions for the CSS3 properties we'll need to set.
translateString = (t) -> " translate3d(#{f t.x}px,#{f t.y}px,#{f t.z}px) "
rotateString = (r, revert) ->
  rX = " rotateX(#{f r.x}deg) "
  rY = " rotateY(#{f r.y}deg) "
  rZ = " rotateZ(#{f r.z}deg) "
  if revert then rZ+rY+rX else rX+rY+rZ
scaleString = (s) -> " scale(#{f s}) "
perspectiveString = (p) -> " perspective(#{f p}px) "

# `computeWindowScale` counts the scale factor between window size and size
# defined for the presentation in the config.
computeWindowScale = ->
  hScale = window.innerHeight / config.height
  wScale = window.innerWidth / config.width
  scale = if hScale > wScale then wScale else hScale
  
  if config.maxScale && scale > config.maxScale
    scale = config.maxScale
  
  if config.minScale && scale < config.minScale
    scale = config.minScale

  scale

windowScale = null

barf = 3
   
Emberspective.StyleByHashMixin = Ember.Mixin.create
  css: (newProperties) -> 
    newStyleHash = Em.$.extend({}, @get("styleHash"), newProperties)
    @set 'styleHash', newStyleHash

  styleHash: {} 

  _styleHashChanged: ( ->
    Ember.run.scheduleOnce 'afterRender', @, '_updateStyle'
  ).observes('styleHash')

  _updateStyle: -> 
    styleHash = @get('styleHash')
    @$().css styleHash

  didInsertElement: ->
    @_super()
    @_styleHashChanged()

Emberspective.GraphNodeView = Ember.View.extend Emberspective.StyleByHashMixin,
  classNames: 'graph-node-view'
  templateName: 'graph_node'
  classNameBindings: ['controller.active']

  styleHash:
    'transform-style': 'preserve-3d'
    position: 'absolute'

  transform: Ember.computed.alias 'controller.transform'
  transformChanged: ( ->
    transform = @get('transform')
    @css
      transform: "translate(-50%,-50%)" +
                 translateString(transform.translation) +
                 rotateString(transform.rotation) +
                 scaleString(transform.scale)
  ).observes('transform')

initialCanvasAndRootCSS = 
  'transform-style': 'preserve-3d'
  'transform-origin': 'top left'
  'transition': 'all 0s ease-in-out'
  position: 'absolute'

Emberspective.GraphCanvasView = Ember.CollectionView.extend Emberspective.StyleByHashMixin,
  classNames: 'graph-canvas-view'.w()
  itemViewClass: Emberspective.GraphNodeView

  styleHash: initialCanvasAndRootCSS

  # GraphCanvasView is never explicitly provided a controller,
  # so it internally resolves to its parent view's controller: GraphController
  contentBinding: 'controller'

  createChildView: (view, attrs) ->
    # Override createChildView to inject a GraphNodeController.
    view = @_super(view, attrs)
    nodeObject = view.get('content')
    view.set 'controller', @get('controller').controllerForNode(nodeObject)
    view

Emberspective.GraphView = Ember.ContainerView.extend Emberspective.StyleByHashMixin,
  classNames: 'graph-view'.w()
  childViews: ['canvasView']
  canvasView: Emberspective.GraphCanvasView

  styleHash: Em.$.extend initialCanvasAndRootCSS,
    top: '50%'
    left: '50%'

  currentState:
    translate: { x: 0, y: 0, z: 0 }
    rotate:    { x: 0, y: 0, z: 0 }
    scale:     1

  didInsertElement: ->
    @_super()

    # Set the viewport meta tag for mobile support
    meta = Em.$("meta[name='viewport']")[0] || document.createElement("meta")
    meta.content = "width=device-width, minimum-scale=1, maximum-scale=1, user-scalable=no"
    unless meta.parentNode == document.head
      meta.name = 'viewport'
      document.head.appendChild(meta)

    windowScale ||= computeWindowScale()
    @css
      transform: perspectiveString( config.perspective/windowScale ) + scaleString( windowScale )

    # Set styles required for GraphView
    document.documentElement.style.height = '100%'
    $('body').css
      height: '100%'
      overflow: 'hidden'

#transition: all 1000ms ease-in-out 0ms;
#-webkit-transition: all 1000ms ease-in-out 0ms;
#-webkit-transform: perspective(5000px) scale(0.2);
