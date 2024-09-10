class ParticipationTestService
  def initialize(get_session_key, set_session_key, test, assessment_participation)
    @set_session_key = set_session_key
    @get_session_key = get_session_key
    @assessment_participation = assessment_participation
    @test = test
    raise ActiveRecord::RecordNotFound, "Test not found" unless @test
    @assessment_test = AssessmentTest.find_by(test: test, assessment: assessment_participation.assessment)
    raise ActiveRecord::RecordNotFound, "AssessmentTest not found" unless @assessment_test
  end

  def reset
    @set_session_key.call("preview", false)
    @set_session_key.call("question_index", 0)
    @set_session_key.call("passed_questions_count", 0)
    @set_session_key.call("question_started_at", nil)
  end

  def start_test(test)
    reset
    @set_session_key.call("preview", false)
  end

  def start_practice_test(test)
    reset
    @set_session_key.call("preview", true)
    @set_session_key.call("question_index", 0)
    @set_session_key.call("passed_questions_count", 0)
  end

  def passed_questions_count
    if preview
      (@get_session_key.call("passed_questions_count") || 0) + 1
    else
      @assessment_test.answered_questions(@assessment_participation.id).count
    end
  end

  def questions_count
    if preview
      @test.preview_questions.count
    else
      @test.non_preview_questions.count
    end
  end

  def current_question
    if preview
      question = @test.preview_questions[@get_session_key.call("question_index")]
    else
      question = @assessment_test.unanswered_questions(@assessment_participation.id).first
    end
    raise ActiveRecord::RecordNotFound, "Question not found" unless question
    question
  end

  def question_started_at
    @get_session_key.call("question_started_at")
  end

  def preview
    @get_session_key.call("preview") || false
  end

  def start_question
    question = current_question
    @set_session_key.call("question_started_at", Time.zone.now.to_s)
    # Save empty answer in case the user skips the question or closes the browser
    save_answer([], question: question)
  end

  def start_question_preview
    @set_session_key.call("question_started_at", Time.zone.now.to_s)
  end

  def next_question
    @set_session_key.call("question_index", 1 + (@get_session_key.call("question_index") || 0))
    @set_session_key.call("passed_questions_count", 1 + (@get_session_key.call("passed_questions_count") || 0))
  end

  def has_more_questions?
    if preview
      @get_session_key["question_index"] < questions_count
    else
      @assessment_test.unanswered_questions(@assessment_participation.id).any?
    end
  end

  def save_answer(selected_options_ids, question: nil)
    if !preview
      current_question = question || self.current_question
      selected_options = if current_question.is_a?(MultipleResponseQuestion)
          current_question.options.where(id: selected_options_ids)
        else
          current_question.options.where(id: selected_options_ids.first)
        end
      current_test_question = TestQuestion.find_by(test: @test, question: current_question)
      raise ActiveRecord::RecordNotFound, "TestQuestion not found" unless current_test_question

      question_answer = QuestionAnswer.find_or_initialize_by(
        test_question: current_test_question,
        assessment_participation: @assessment_participation,
      )

      question_answer.content = { selected_options_ids: selected_options&.map(&:id) }
      duration_left = Time.zone.now - Time.zone.parse(question_started_at)
      is_correct = selected_options.all?(&:correct) && selected_options.count.positive?
      question_answer.is_correct = is_correct && (duration_left || -1).positive?
      question_answer.save
    end
  end
end
