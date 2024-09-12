class ParticipationTestService
  include ParticipationTestErrors

  def initialize(get_session_key, set_session_key, test, assessment_participation)
    @set_session_key = set_session_key
    @get_session_key = get_session_key
    @assessment_participation = assessment_participation
    @test = test
    raise TestNotFoundError unless @test
  end

  def start_test
    reset
  end

  def start_practice_test
    reset
    @set_session_key.call('preview', true)
  end

  def current_question
    question = if preview
                 @test.preview_questions[@get_session_key.call('question_index')]
               else
                 @assessment_participation.unanswered_questions(@test).first
               end

    raise QuestionNotFoundError.new(@test.id, question.id) if question.nil?

    question
  end

  def answere_question(args)
    params = args[:params]
    selected_options_ids = params[:selected_options]
    question_id = params[:question_id]
    raise QuestionNotFoundError unless question_id.present?
    
    question = Question.find(question_id)
    if preview
      next_question
    else
      save_question_answer(question, find_selected_options(question, selected_options_ids))
    end
  end

  def more_questions?
    if preview
      @get_session_key.call('question_index') < questions_count
    else
      @assessment_participation.unanswered_questions(@test).any?
    end
  end

  def questions_count
    if preview
      @test.preview_questions.count
    else
      @test.non_preview_questions.count
    end
  end

  def passed_questions_count
    if preview
      (@get_session_key.call('passed_questions_count') || 0) + 1
    else
      @assessment_participation.answered_questions(@test).count + 1
    end
  end

  def next_question
    @set_session_key.call('question_index', 1 + (@get_session_key.call('question_index') || 0))
    @set_session_key.call('passed_questions_count', 1 + (@get_session_key.call('passed_questions_count') || 0))
  end

  def start_question
    set_question_started_at_now
  end

  def start_question_preview
    set_question_started_at_now
  end

  def question_started_at
    @get_session_key.call('question_started_at')
  end

  def preview
    @get_session_key.call('preview') || false
  end

  private

  def set_question_started_at_now
    @set_session_key.call('question_started_at', Time.zone.now.to_s)
  end

  def find_selected_options(question, selected_options_ids)
    return nil unless selected_options_ids

    if question.is_a?(MultipleResponseQuestion)
      question.options.where(id: selected_options_ids)
    else
      question.options.where(id: selected_options_ids.first)
    end
  end

  def save_question_answer(question, selected_options)
    current_test_question = TestQuestion.find_by(test: @test, question:)
    raise TestQuestionNotFoundError.new(@test.id, question.id) unless current_test_question

    question_answer = QuestionAnswer.find_or_initialize_by(
      test_question: current_test_question,
      assessment_participation: @assessment_participation
    )

    question_answer.content = { selected_options_ids: selected_options&.map(&:id) }
    question_answer.is_correct = correct_answer?(selected_options) && question_has_more_time? || false
    question_answer.save!
  end

  def correct_answer?(selected_options)
    selected_options&.all?(&:correct) && selected_options&.any?
  end

  def question_has_more_time?
    duration_left = Time.zone.now - Time.zone.parse(question_started_at)
    duration_left.positive?
  end

  def reset
    @set_session_key.call('preview', false)
    @set_session_key.call('question_index', 0)
    @set_session_key.call('passed_questions_count', 0)
    @set_session_key.call('question_started_at', nil)
  end
end
