class ModifyAssessmentParticipationColumns < ActiveRecord::Migration[7.1]
  def change
    # Change device_used to devices
    remove_column :assessment_participations, :device_used, :string
    add_column :assessment_participations, :devices, :jsonb, default: [], null: false

    # Change location to locations
    remove_column :assessment_participations, :location, :string
    add_column :assessment_participations, :locations, :jsonb, default: [], null: false

    # Change single_ip_address to ips
    remove_column :assessment_participations, :single_ip_address, :boolean
    add_column :assessment_participations, :ips, :jsonb, default: [], null: false
  end
end
