class ParticipationTestService
  def initialize(session, test)
    @progress_service = ParticipationProgressService.new(session)
    @progress_service.set_property("test_id", test.id)
  end

  def start_test(test)
    @progress_service.reset
    @progress_service.set_property("preview", false)
    @progress_service.set_property("test_id", test.id)
    @progress_service.set_property("question_index", 0)
    @progress_service.set_property("passed_questions_count", 0)
    @progress_service.set_property("questions_count", test.non_preview_questions.count)
  end

  def start_practice_test(test)
    @progress_service.reset
    @progress_service.set_property("test_id", test.id)
    @progress_service.set_property("preview", true)
    @progress_service.set_property("question_index", 0)
    @progress_service.set_property("passed_questions_count", 0)
    @progress_service.set_property("questions_count", test.preview_questions.count)
  end

  def preview
    @progress_service.preview
  end

  def start_question()
    @progress_service.set_property("question_started_at", Time.zone.now.to_s)
  end

  def next_question
    @progress_service.set_property("question_index", @progress_service.get_progress["question_index"] + 1)
    @progress_service.set_property("passed_questions_count", @progress_service.get_progress["passed_questions_count"] + 1)
  end

  def assessment_participation
    @progress_service.assessment_participation
  end

  def has_more_questions?
    @progress_service.get_progress["question_index"] < @progress_service.get_progress["questions_count"]
  end

  def save_answer(selected_options_ids)
    current_question = @progress_service.question
    if !@progress_service.preview
      selected_options = current_question.is_a?(MultipleResponseQuestion) ? current_question.options.where(id: selected_options_ids) : current_question.options.where(id: selected_options_ids.first)
      current_test_question = TestQuestion.find_by(test: @progress_service.test, question: current_question)
      question_answer = QuestionAnswer.find_or_initialize_by(
        test_question: current_test_question,
        assessment_participation: @progress_service.assessment_participation,
      )
      question_answer.content = { selected_options_ids: selected_options&.map(&:id) }
      duration_left = @progress_service.calculate_duration_left
      is_correct = selected_options.all? { |option| option.correct }
      question_answer.is_correct = is_correct && (duration_left || -1)&.positive?
      question_answer.save
    end
  end
end
