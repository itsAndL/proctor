class AddCaseInsensitiveIndexToTempCandidatesEmail < ActiveRecord::Migration[7.1]
  def up
    enable_extension 'citext'
    change_column :temp_candidates, :email, :citext
    add_index :temp_candidates, :email, unique: true
  end

  def down
    remove_index :temp_candidates, :email
    change_column :temp_candidates, :email, :string
    disable_extension 'citext'
  end
end
