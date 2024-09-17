class AddDurationSecondsToTests < ActiveRecord::Migration[7.1]
  def change
    add_column :tests, :duration_seconds, :integer, default: 0, null: false
  end
end
