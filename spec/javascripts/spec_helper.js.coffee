
window.SAMPLE_EMBERSPECTIVE_TREE =
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

window.SAMPLE_EMBERSPECTIVE_TREE_FLATTENED = [
  SAMPLE_EMBERSPECTIVE_TREE,
  SAMPLE_EMBERSPECTIVE_TREE.children[0],
  SAMPLE_EMBERSPECTIVE_TREE.children[1],
  SAMPLE_EMBERSPECTIVE_TREE.children[1].children[0],
  SAMPLE_EMBERSPECTIVE_TREE.children[2],
]

chai.Assertion.includeStack = true
