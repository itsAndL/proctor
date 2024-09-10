class AddActiveAndBusinessToTests < ActiveRecord::Migration[7.1]
  def change
    add_column :tests, :active, :boolean, default: true
    add_reference :tests, :business, null: true, foreign_key: true
  end
end
