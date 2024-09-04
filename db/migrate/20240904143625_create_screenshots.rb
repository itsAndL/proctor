class CreateScreenshots < ActiveRecord::Migration[7.1]
  def change
    create_table :screenshots do |t|
      t.references :assessment_participation, null: false, foreign_key: true

      t.timestamps
    end
  end
end
