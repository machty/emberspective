
FactoryGirl.define do
  factory :status_node do
    name "Ember"
    description "Here is a description of a status node."
    author "machty"
    updated_at DateTime.now
    children []
    version "100"

    factory :root_status_node do
      children { [ 
        build(:status_node, 
          name: "Router", 
          version: "150",
          updated_at: DateTime.parse("April 6, 2006"),
          children: [ 
            build(:status_node, 
                  name: "Query Strings",
                  description: "Add query string support to routes",
                  version: "300",
                  author: "ghempton",
                  updated_at: DateTime.parse("April 15, 2006"),
            ), 
            build(:status_node, 
                  name: "Haltable Transitions",
                  description: "Add haltable transitions to the router",
                  version: "400",
                  author: "kselden",
                  updated_at: DateTime.parse("April 25, 2006"),
            ),
          ]
        ),
        build(:status_node, 
              name: "Perf",
              description: "Performance improves to Ember",
              version: "200",
              author: "tomdale",
              updated_at: DateTime.parse("April 10, 2006"),
        ),
        build(:status_node, 
              name: "Templates",
              description: "Enhancements to Handlebars and related stuff",
              version: "500",
              author: "wycats",
              updated_at: DateTime.parse("April 30, 2006"),
        ),
      ] }
    end
  end
end
