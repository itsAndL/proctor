class AddArchivedAtToAssessments < ActiveRecord::Migration[7.1]
  def change
    add_column :assessments, :archived_at, :datetime
  end
end
