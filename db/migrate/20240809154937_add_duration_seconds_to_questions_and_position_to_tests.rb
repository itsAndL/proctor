class AddDurationSecondsToQuestionsAndPositionToTests < ActiveRecord::Migration[7.1]
  def change
    add_column :questions, :duration_seconds, :integer, default: 0
    add_column :tests, :position, :integer
  end
end
