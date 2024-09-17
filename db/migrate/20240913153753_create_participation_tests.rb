class CreateParticipationTests < ActiveRecord::Migration[7.1]
  def change
    create_table :participation_tests do |t|
      t.datetime :started_at
      t.datetime :completed_at
      t.integer :status, default: 0
      t.belongs_to :assessment_participation, null: false, foreign_key: true
      t.belongs_to :test, null: false, foreign_key: true
      t.timestamps
    end

    add_index :participation_tests, %i[assessment_participation_id test_id], unique: true, name: 'index_participation_tests_on_assessment_participation_and_test'
  end
end
