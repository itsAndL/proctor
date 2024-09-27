# frozen_string_literal: true

class AssessmentParticipationService
  include Rails.application.routes.url_helpers

  def initialize(assessment_participation)
    @assessment_participation = assessment_participation
    @assessment = @assessment_participation.assessment
  end

  def start
    @assessment_participation.started! if @assessment_participation.invited? || @assessment_participation.invitation_clicked?
    create_participation_tests
    determine_next_url
  end

  def invitataion_clicked
    @assessment_participation.invitation_clicked! if @assessment_participation.invited?
  end

  def complete
    @assessment_participation.completed! if @assessment_participation.started?
    candidate_assessment_participation_path(hashid: @assessment_participation)
  end

  def start_test(test)
    participation_test = @assessment_participation.participation_tests.find_by(test:)
    return if participation_test.started? || participation_test.completed?

    participation_test.started_at = Time.zone.now
    participation_test.status = :started
    participation_test.save!
  end

  def complete_test(test)
    participation_test = @assessment_participation.participation_tests.find_by(test:)
    participation_test.completed_at = Time.zone.now
    participation_test.status = :completed
    participation_test.save!

    return candidate_test_path(hashid: first_unanswered_test) if first_unanswered_test
    return start_candidate_custom_question_path(first_unanswered_custom_question) if first_unanswered_custom_question

    checkout_candidate_assessment_participation_path(hashid: @assessment_participation)
  end

  def first_unanswered_test
    @assessment_participation.unanswered_tests.first
  end

  def first_unanswered_question(test)
    participation_test = @assessment_participation.participation_tests.find_by(test:)
    participation_test.unanswered_questions.first
  end

  def create_question_answer(test, question, params)
    return test.next_preview if question.preview

    participation_test = @assessment_participation.participation_tests.find_by(test:)
    selected_options_ids = params[:selected_options]
    selected_options = find_selected_options(question, selected_options_ids)
    test_question = test.test_questions.find_by(question:)
    question_answer = @assessment_participation.question_answers.find_or_initialize_by(test_question:)
    question_answer.content = { selected_options_ids: selected_options&.map(&:id) }
    question_answer.is_correct = participation_test.more_time? && correct_answer?(selected_options)
    question_answer.save!
    first_unanswered_question(test)
  end

  def more_questions?(test)
    participation_test = @assessment_participation.participation_tests.find_by(test:)
    participation_test.unanswered_questions.any?
  end

  def correct_answer?(selected_options)
    return false unless selected_options

    selected_options.all?(&:correct)
  end

  def time_left(test)
    participation_test = @assessment_participation.participation_tests.find_by(test:)
    test.duration_seconds - (Time.zone.now - (participation_test.started_at || Time.zone.now))
  end

  def time_left_overall
    @assessment_participation.unanswered_tests.sum { |test| time_left(test) }
  end

  def more_custom_questions?
    @assessment_participation.unanswered_custom_questions.any?
  end

  def first_unanswered_custom_question
    @assessment_participation.unanswered_custom_questions.first
  end

  def start_custom_question(custom_question)
    custom_question_response = @assessment_participation.custom_question_responses.find_or_initialize_by(custom_question:)
    custom_question_response.started! if custom_question_response.pending?
    custom_question_response.save! if custom_question_response.changed?
  end

  def create_custom_question_answer(custom_question, params)
    response = @assessment_participation.custom_question_responses.find_or_initialize_by(custom_question:)
    case custom_question
    when EssayCustomQuestion
      response.essay_content = params[:essay_content]
    when FileUploadCustomQuestion
      response.file_upload = params[:file_upload]
    when VideoCustomQuestion
      response.video = params[:video]
    end
    response.status = :completed
    response.save!
  end

  private

  def determine_next_url
    if @assessment_participation.unanswered_tests.any?
      candidate_test_path(hashid: first_unanswered_test)
    elsif @assessment_participation.unanswered_custom_questions.any?
      start_candidate_custom_question_path(first_unanswered_custom_question)
    else
      checkout_candidate_assessment_participation_path(hashid: @assessment_participation)
    end
  end

  def find_selected_options(question, selected_options_ids)
    return nil unless selected_options_ids

    if question.is_a?(MultipleResponseQuestion)
      question.options.where(id: selected_options_ids)
    else
      question.options.where(id: selected_options_ids.first)
    end
  end

  def create_participation_tests
    @assessment.tests.each do |test|
      @assessment_participation.participation_tests.create(test:, status: :pending) unless @assessment_participation.participation_tests.exists?(test:)
    end
  end
end
