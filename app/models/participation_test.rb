class ParticipationTest < ApplicationRecord  
  after_find :set_status
  belongs_to :assessment_participation
  belongs_to :test
  enum status: { started: 0, completed: 1 }

  validates :started_at, presence: true

  def set_status
    self.status = :completed if completed_at.present? || calculate_time_taken > test.duration
  end

  def calculate_time_taken
    test.duration - started_at
  end 
end
