class ParticipationProgressService
  def initialize(session)
    @session = session
  end

  def reset
    current_assessment_participation = assessment_participation&.id
    @session["participation_progress"] = {}
    @session["participation_progress"]["current_assessment_participation_id"] = current_assessment_participation
  end

  def reset_all
    @session["participation_progress"] = {}
  end

  def assessment_participation
    @assessment_participation ||= AssessmentParticipation.find(get_progress["current_assessment_participation_id"]) if get_progress["current_assessment_participation_id"]
  end

  def current_business
    assessment_participation&.assessment&.business
  end

  def get_progress
    @session["participation_progress"]
  end

  def questions_count
    get_progress["questions_count"] || 0
  end

  def custom_question
    assessment_participation&.unanswered_custom_questions[get_progress["custom_question_id"]] if get_progress["custom_question_id"]
  end

  def question
    if preview
      test.preview_questions[get_progress["question_index"]] if get_progress["question_index"]
    else
      test.non_preview_questions[get_progress["question_index"]] if get_progress["question_index"]
    end
  end

  def test
    assessment_participation&.assessment&.tests&.find(get_progress["test_id"]) if get_progress["test_id"]
  end

  def preview
    get_progress["preview"] || false
  end

  def passed_questions_count
    1 + (get_progress["passed_questions_count"] || 0)
  end

  def question_started_at
    get_progress["question_started_at"]
  end

  def set_property(key, value)
    get_progress[key] = value
  end

  def has_more_questions?
    get_progress["question_index"] < get_progress["questions_count"]
  end

  def calculate_duration_left
    question_duration = question&.duration_seconds || 0
    question_started_at = question_started_at

    return question_duration unless question_started_at

    elapsed_time = Time.current - Time.parse(question_started_at)
    [question_duration - elapsed_time.to_i, 0].max
  end
end
