
Emberspective.GraphNode = Ember.ObjectProxy.extend
  parent: null
  stub: ( ->
    stub = @get('name').dasherize().replace(/[^a-z-]/g,'')
    parentStub = @parent?.get('stub')
    stub = "#{parentStub}-#{stub}" if parentStub
    stub
  ).property()
  children: null

# Return a flattened array of decorated node objects.
getNodes = (node, accum, parent = null) ->
  me = Emberspective.GraphNode.create
    content: node
    parent: parent
  accum.push me
  childrenNodes = []
  for childNode in (node.children || [])
    childrenNodes.push getNodes(childNode, accum, me, me) 
  me.set 'children', childrenNodes
  me

# Override this for testing purposes.
Emberspective.GraphNode.FIXTURE_DATA = 
  {
    name: "Ember"
    description: "The JavaScript framework you know and love."
    children: [
      {
        name: "Snork"
        description: "Foo"
      },
      {
        name: "Bork"
        description: "Foo"
      },
      {
        name: "Perf"
        description: "Performance"
      },
      {
        name: "Router"
        description: "Router Stuff"
        children: [
          {
            name: "Blorg"
            description: "Transition Stuff"
            children: [
              {
                name: "Blorg"
                description: "Transition Stuff"
              },
              {
                name: "Transitions"
                description: "Transition Stuff"
              },
              {
                name: "OMG"
                description: "oh my god"
              },
            ]
          },
          {
            name: "Transitions"
            description: "Transition Stuff"
            children: [
              {
                name: "Blorg"
                description: "Transition Stuff"
              },
              {
                name: "Transitions"
                description: "Transition Stuff"
              },
              {
                name: "OMG"
                description: "oh my god"
                children: [
                  {
                    name: "Blorg"
                    description: "Transition Stuff"
                  },
                  {
                    name: "OMG"
                    description: "oh my god"
                    children: [
                      {
                        name: "Blorg"
                        description: "Transition Stuff"
                      },
                      {
                        name: "OMG"
                        description: "oh my god"
                      },
                    ]
                  },
                ]
              },
            ]
          },
          {
            name: "OMG"
            description: "oh my god"
          },
        ]
      },
      {
        name: "View"
        description: "View Stuff"
      },
    ]
  }

readTreeDataFromDOM = ->
  throw new Error 'not implemented'

cachedTreeData = null
treeData = ->
  cachedTreeData ||= Emberspective.GraphNode.FIXTURE_DATA
  unless cachedTreeData
    cachedTreeData ||= readTreeDataFromDOM
  cachedTreeData

cachedNodes = null
Emberspective.GraphNode.findAll = ->
  return cachedNodes if cachedNodes
  nodes = []
  getNodes(treeData(), nodes)
  cachedNodes = nodes

