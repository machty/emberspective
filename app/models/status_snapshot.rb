class StatusSnapshot < ActiveRecord::Base
  attr_accessible :error_message, :failed, :raw_json, :tree

  serialize :tree, StatusNode

  %w{ tree raw_json version }.each do |attr|
    validates attr.to_sym, presence: true, :unless => :failed?
  end

  validate :json_is_valid
  validates :error_message, presence: true, :if => :failed?

  def stale?
    created_at < DateTime.now - 10.minutes
  end

  class << self

    def successful
      where(failed: false)
    end

    def latest
      order('created_at ASC')
    end

    def from_stypi_json(json_string)

      last_snapshot = latest.successful.last
      new_snapshot_hash = JSON.parse(json_string)

      # Only create a new snapshot if there's a newer version.
      if last_snapshot && new_snapshot_hash["version"].to_s == last_snapshot.version.to_s
        return last_snapshot
      end

      # Create and return the new snapshot
      new.tap do |snapshot|
        snapshot.tree = StatusNode.from_stypi_hash(new_snapshot_hash, last_snapshot && JSON.parse(last_snapshot.raw_json))
        snapshot.version = snapshot.tree.latest_child_version
        snapshot.raw_json = json_string
        snapshot.save!
      end
    rescue StandardError => e
      new_failed(e.message)
    end

    def new_failed(error_message)
      new.tap do |snapshot|
        snapshot.failed = true
        snapshot.error_message = error_message
        snapshot.save!
      end
    end
  end

  protected

  # TODO: Hack! FactoryGirl tries to invoke `singleton_method_added=` for some reason?
  attr_accessor :singleton_method_added if Rails.env.test?

  def json_is_valid
    JSON.parse raw_json if raw_json.present?
  rescue
    errors[:raw_json] << "must be valid JSON"
  end
end

