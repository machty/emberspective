class CreateStatusSnapshots < ActiveRecord::Migration
  def change
    create_table :status_snapshots do |t|
      t.text :raw_json
      t.boolean :failed, default: false
      t.text :error_message
      t.text :tree
      t.string :version

      t.timestamps
    end
  end
end
