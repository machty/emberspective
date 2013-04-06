#require 'minitest/autorun'
require 'spec_helper'

describe StatusSnapshot do

  let(:first_snapshot)  { StatusSnapshot.from_stypi_json raw_stypi_snapshot(1) } 
  let(:second_snapshot) { StatusSnapshot.from_stypi_json raw_stypi_snapshot(2) } 

  describe "from_stypi_json" do
    it "returns a StatusSnapshot instance given json from stypi" do
      first_snapshot.should be_instance_of StatusSnapshot
    end

    it "doesn't create two separate snapshots for the same json" do
      first_snapshot.save!
      StatusSnapshot.from_stypi_json(raw_stypi_snapshot(1)).should == first_snapshot
    end
  end

  it "has a #tree method that returns a StatusNode with StatusNode children" do
    first_snapshot.tree.should be_instance_of StatusNode
    first_snapshot.tree.children.first.should be_instance_of StatusNode
  end

  describe "validations" do
    let(:snapshot) { build :status_snapshot }

    it "has a proper validating factory" do
      snapshot.should be_valid
    end

    describe "successful snapshot" do
      it "cannot be saved without raw_json" do
        snapshot.raw_json = nil
        snapshot.should_not be_valid
      end

      it "must have an error message if failed is true" do
        snapshot.failed = true
        snapshot.should_not be_valid
        snapshot.error_message = "Something really wack happened"
        snapshot.should be_valid
      end

      it "must have a tree" do
        snapshot.tree = nil
        snapshot.should_not be_valid
      end 
    end

    #describe "failed snapshot" do
      #let(:snapshot) { build :failed_status_snapshot }
    #end
  end
end

