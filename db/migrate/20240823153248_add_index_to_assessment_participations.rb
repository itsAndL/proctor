class AddIndexToAssessmentParticipations < ActiveRecord::Migration[7.1]
  def change
    add_index :assessment_participations, [:assessment_id, :candidate_id], unique: true, name: 'index_on_assessment_and_candidate'
    add_index :assessment_participations, [:assessment_id, :temp_candidate_id], unique: true, name: 'index_on_assessment_and_temp_candidate'
  end
end
