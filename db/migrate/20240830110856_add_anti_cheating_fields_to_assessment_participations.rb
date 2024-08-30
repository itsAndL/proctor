class AddAntiCheatingFieldsToAssessmentParticipations < ActiveRecord::Migration[7.1]
  def change
    add_column :assessment_participations, :device_used, :string
    add_column :assessment_participations, :location, :string
    add_column :assessment_participations, :single_ip_address, :boolean
    add_column :assessment_participations, :webcam_enabled, :boolean
    add_column :assessment_participations, :fullscreen_always_active, :boolean
    add_column :assessment_participations, :mouse_always_in_window, :boolean
  end
end
