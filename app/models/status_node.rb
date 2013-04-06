require 'yaml'

class StatusNode
  include ActiveModel::Serialization

  attr_accessor :name, :description, :author, :updated_at, :children, :version, :latest_child_version

  def attributes
    {
      'name' => name,
      'description' => description,
      'author' => author,
      'updated_at' => updated_at,
      'children' => children,
      'version' => version,
    }
  end

  class << self
    def from_stypi_hash(new_hash, old_hash)

      reconciled_deltas = reconcile_deltas(new_hash["version"], 
                                       new_hash["head"]["deltas"], 
                                       old_hash && !Rails.env.test? && old_hash["head"]["deltas"])

      status_node = new
      preprocessed_yaml_string = preprocess_before_yaml(reconciled_deltas)

      # We need to fetch the last timestamp
      header = preprocessed_yaml_string.first preprocessed_yaml_string.index("tree:")
      current_timestamp = header.scan(/<<<(.*?)>>>/).map{ |match| match.first.split('|') }.last

      snapshot = YAML.load preprocessed_yaml_string
      unprocessed_tree = snapshot["tree"]

      usernames_to_ids = snapshot["users"]
      ids_to_username = {}
      usernames_to_ids.each { |k,v| ids_to_username[v] = k }

      latest_version = "0"

      generate_tree_from = Proc.new do |node_hash_with_markup|
        node = StatusNode.new
        timestamps = []

        node_hash = {}
        node_hash_with_markup.each do |k,v|
          timestamp_test_string = k
          timestamp_test_string += v if v.is_a?(String)
          new_timestamps = timestamp_test_string.scan(/<<<(.*?)>>>/).map { |match| match.first.split('|') }
          timestamps = timestamps.concat(new_timestamps)

          k = strip_markup(k)
          if v.is_a?(String)
            v = strip_markup(v)
            node.send "#{k}=", v 
          end
          node_hash[k] = v
        end

        # Choose latest timestamp to use for this node, but
        # we'll use the last one as the current one to pass on 
        # for children nodes.
        most_recent = timestamps.max { |a,b| a[2].to_i <=> b[2].to_i }
        node.author, node.updated_at, node.version = (most_recent || current_timestamp)

        latest_version = ([node.version.to_i, latest_version.to_i].max).to_s

        # Convert author name to nickname if mapping exists.
        node.author = ids_to_username[node.author] || "Unknown"

        # Set the prevailing current_timestamp to the last one encountered.
        current_timestamp = timestamps.last || current_timestamp

        # Process children.
        node.children = (node_hash["children"] || []).map { |child| generate_tree_from.(child) } 
        node
      end

      generate_tree_from.(unprocessed_tree).tap do |tree|
        tree.latest_child_version = latest_version
      end
    end

    def strip_markup(s)
      s.gsub(/<<<(.*)>>>/, '')
    end

    # Returns new deltas with correct versions and timestamps based
    # on a previous list of deltas.
    def reconcile_deltas(new_version, new_deltas, old_deltas)
      old_deltas ||= []
      new_version = new_version.to_s

      now = DateTime.now.to_s(:db)

      new_deltas.map do |delta|
        { "text" => delta["text"], 
          "authorId" => delta["attributes"]["authorId"] 
        }.tap do |new_delta|

          # Try to find new in old.
          found_index = old_deltas.find_index do |old_delta|
            authors_are_same = old_delta["authorId"] == new_delta["authorId"]
            old_text_begins_with_new_text = old_delta["text"].index(new_delta["text"])
            authors_are_same && old_text_begins_with_new_text
          end

          if found_index
            found = old_deltas[found_index]
            #old_deltas = old_deltas.drop(found_index + 1)

            # Set timestamp/version to old.
            new_delta["version"]    = found["version"]
            new_delta["updated_at"] = found["updated_at"]
          else
            # Use current version.
            new_delta["version"]    = new_version
            new_delta["updated_at"] = now
          end
        end
      end
    end

    def preprocess_before_yaml(reconciled_deltas)
      reconciled_deltas.map do |delta|
        markup = "<<<#{delta["authorId"]}|#{delta["updated_at"]}|#{delta["version"]}>>>"

        # We don't want to screw up YAML syntax, so insert markup between letters
        text = delta["text"]
        index = text =~ /[A-Za-z]{2}/
        text = text.insert(index + 1, markup) if index
        text
      end.join
    end
  end
end

