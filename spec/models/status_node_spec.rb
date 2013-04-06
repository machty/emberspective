require 'spec_helper'
require 'json'
require 'yaml'

describe StatusNode do
  # it has to be loaded from a DB, right?
  # It has to be saved to DB. 
  let(:first_stypi_hash) { JSON.parse(raw_stypi_snapshot(1)) }
  let(:second_stypi_hash) { JSON.parse(raw_stypi_snapshot(2)) }

  let(:old_snapshot) { JSON.parse File.read(Rails.root.join('spec', 'support', "old_snapshot.json")) }

  before :each do
    @now = DateTime.now 
    DateTime.stub(:now) { @now }
  end

  describe "from_stypi_hash class method" do

    let(:status_node) { StatusNode.from_stypi_hash(second_stypi_hash, old_snapshot) }

    it "returns a StatusNode" do
      status_node.should be_instance_of StatusNode
    end

    it "has an #updated_at and #author" do
      status_node.updated_at.should == @now.to_s(:db)
      status_node.author.should == "Unknown"
    end

    it "knows its version" do
      status_node.version.should == "200"
    end
  end

  describe "conversion to yaml" do

    let(:reconciled_deltas) do 
      StatusNode.reconcile_deltas(second_stypi_hash["version"], 
                                  second_stypi_hash["head"]["deltas"], 
                                  old_snapshot["head"]["deltas"])
    end

    describe "reconcile_deltas class method" do
      def second_delta_should_have_changed(results)
        delta_should_have_values(results[1], @now.to_s(:db), second_stypi_hash["version"].to_s)
      end

      def delta_should_have_values(delta, updated_at, version)
        delta["updated_at"].should == updated_at
        delta["version"].should == version
      end

      it "works without a list of old deltas" do

        results = StatusNode.reconcile_deltas(second_stypi_hash["version"], 
                                              second_stypi_hash["head"]["deltas"], nil)
        results.length.should == 3
        second_delta_should_have_changed(results)
      end

      it "preserves old versions from the old deltas" do
        old_deltas = old_snapshot["head"]["deltas"]
        results = reconciled_deltas
        second_delta_should_have_changed(results)

        # But first and third should have old versions
        old_updated_at = old_deltas[0]["updated_at"]
        old_version = old_snapshot["version"]
        delta_should_have_values(results[0], old_updated_at, old_version)
        delta_should_have_values(results[2], old_updated_at, old_version)
      end
    end

    describe "preprocess_before_yaml class method" do
      let(:result) { StatusNode.preprocess_before_yaml(reconciled_deltas) }

      it "accepts reconciled deltas and returns a valid YAML concatenated string of deltas with author/version markup" do
        result.should match /<<<5158c5563b8cc4e6a400569c\|2013-04-04 12:27:27\|100>>>/
        YAML.load(result).should be_instance_of Hash
      end
    end
  end
end
