class MoveDurationSecondsFromQuestionsToTests < ActiveRecord::Migration[7.1]
  def change
    remove_column :questions, :duration_seconds, :integer, default: 0
    add_column :tests, :duration_seconds, :integer, default: 0, null: false
  end
end
