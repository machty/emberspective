class StatusSnapshotsController < ApplicationController
  def show
    cached_snapshot = StatusSnapshot.latest.last
    if cached_snapshot.nil? || cached_snapshot.stale? || cached_snapshot.failed?
      # Fetch new Stypi snapshot
      @status_snapshot = StatusSnapshot.from_stypi_json(Stypi.fetch)
      if @status_snapshot.failed?
        @failed_snapshot = @status_snapshot
        @status_snapshot = StatusSnapshot.latest.successful.last
      end
    else
      @status_snapshot = cached_snapshot
    end
  end
end
