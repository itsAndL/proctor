class CreateParticipationTests < ActiveRecord::Migration[7.1]
  def change
    create_table :participation_tests do |t|
      t.datetime :started_at
      t.datetime :completed_at
      t.integer :status
      t.belongs_to :assessment_participation, null: false, foreign_key: true
      t.belongs_to :test, null: false, foreign_key: true
      t.timestamps
    end
  end
end
