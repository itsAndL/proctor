class AddNotesToAssessmentParticipations < ActiveRecord::Migration[7.1]
  def change
    add_column :assessment_participations, :notes, :text
  end
end
