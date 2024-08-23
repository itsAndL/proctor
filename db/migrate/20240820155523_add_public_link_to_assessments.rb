class AddPublicLinkToAssessments < ActiveRecord::Migration[7.1]
  def change
    add_column :assessments, :public_link_token, :string
    add_index :assessments, :public_link_token, unique: true
    add_column :assessments, :public_link_active, :boolean, default: false
  end
end
