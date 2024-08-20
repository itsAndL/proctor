class CreateAssessmentParticipations < ActiveRecord::Migration[7.1]
  def change
    create_table :assessment_participations do |t|
      t.references :assessment, null: false, foreign_key: true
      t.references :temp_candidate, null: true, foreign_key: true
      t.references :candidate, null: true, foreign_key: true
      t.integer :status
      t.integer :rating

      t.timestamps
    end
  end
end
