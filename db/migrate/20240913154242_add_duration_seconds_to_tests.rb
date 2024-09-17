class AddDurationSecondsToTests < ActiveRecord::Migration[7.1]
  def change
    add_column :tests, :duration_seconds, :integer
  end
end
