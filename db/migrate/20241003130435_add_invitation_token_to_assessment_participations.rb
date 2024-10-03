class AddInvitationTokenToAssessmentParticipations < ActiveRecord::Migration[7.1]
  def change
    add_column :assessment_participations, :invitation_token, :string
    add_index :assessment_participations, :invitation_token, unique: true
  end
end
