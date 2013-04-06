require 'spec_helper'

describe StatusSnapshotsController do

  describe "GET #show" do
    it "sets latest_status_snapshot and status_snapshot to equal when latest snapshot is success" do
      @successful_snapshot = create :status_snapshot
      get :show
      assigns(:status_snapshot).should == @successful_snapshot
    end

    describe "fetching" do

      def should_fetch(successfully = true)
        lambda { get :show }.should change(StatusSnapshot, :count).by(1)
        last = StatusSnapshot.latest.last
        last.should_not == StatusSnapshot.latest.first
        last.should be_persisted
        if successfully
          last.should_not be_failed
        else
          last.should be_failed
        end
      end

      describe "when stypi data is valid" do
        before :each do
          Stypi.stub(:fetch).and_return(raw_stypi_snapshot(1))
        end

        it "fetches if there are no statuses in the db" do
          should_fetch
        end

        it "fetches if last snapshot is failure" do
          @failed_snapshot = create :failed_status_snapshot
          should_fetch
        end

        it "fetches if last snapshot is old enough" do
          @successful_snapshot = create :status_snapshot, created_at: (DateTime.now - 15.minutes)
          should_fetch
        end

        it "doesn't fetch for recent successful snapshots" do
          @successful_snapshot = create :status_snapshot, created_at: (DateTime.now - 1.minutes)
          @successful_snapshot.should_not be_stale
          @successful_snapshot.should_not be_failed
          get :show
          StatusSnapshot.latest.last.should == @successful_snapshot
        end
      end

      describe "when stypi data is invalid" do
        it "creates a failed snapshot" do
          Stypi.stub(:fetch).and_return(raw_stypi_snapshot(nil))
          should_fetch false
        end
      end
    end
  end
end
