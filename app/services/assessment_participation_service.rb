# frozen_string_literal: true

class AssessmentParticipationService
  include Rails.application.routes.url_helpers

  def initialize(assessment_participation)
    @assessment_participation = assessment_participation
    @assessment = @assessment_participation.assessment
  end

  def start
    if @assessment_participation.invited? || @assessment_participation.invitation_clicked?
      @assessment_participation.started!
    end
    @assessment.tests.each do |test|
      unless @assessment_participation.participation_tests.exists?(test:)
        @assessment_participation.participation_tests.create(test:, status: :pending)
      end
    end
    determine_next_url
  end

  def invitataion_clicked
    @assessment_participation.invitation_clicked! if @assessment_participation.invited?
  end

  def complete
    @assessment_participation.completed! if @assessment_participation.started?
    candidate_assessment_participation_path(@assessment_participation)
  end

  def start_test(test)
    participation_test = @assessment_participation.participation_tests.find_by(test:)
    return if started?(test)

    participation_test.started_at = Time.zone.now
    participation_test.status = :started
    participation_test.save!
  end

  def complete_test(test)
    participation_test = @assessment_participation.participation_tests.find_by(test:)
    participation_test.completed_at = Time.zone.now
    participation_test.status = :completed
    participation_test.save!

    return candidate_test_path(first_unanswered_test) if first_unanswered_test

    checkout_candidate_assessment_participation_path(@assessment_participation)
  end

  def first_unanswered_test
    @assessment_participation.unanswered_tests.first
  end

  def first_unanswered_question(test)
    participation_test = @assessment_participation.participation_tests.find_by(test:)
    participation_test.unanswered_questions.first
  end

  def create_question_answer(test, question, params)
    return question.next_preview(test) if question.preview

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

  def first_unanswered_custom_question
    @assessment_participation.custom_questions.non_answered.first
  end

  def create_custom_question_response(custom_question, essay_content: nil, file_upload: nil, video: nil)
    custom_question_response = CustomQuestionResponse.new(custom_question:,
                                                          assessment_participation: @assessment_participation)
    custom_question_response.essay_content = essay_content if essay_content
    custom_question_response.file_upload = file_upload if file_upload
    custom_question_response.video = video if video
    custom_question_response.save!
  end

  def complete_custom_question(custom_question_response)
    custom_question_response.completed_at = Time.zone.now
    custom_question_response.status = 'completed'
    custom_question_response.save!
  end

  def start_custom_question(custom_question_response)
    custom_question_response.started_at = Time.zone.now
    custom_question_response.status = 'started'
    custom_question_response.save!
  end

  def more_questions?(test)
    participation_test = @assessment_participation.participation_tests.find_by(test:)
    participation_test.unanswered_questions.any?
  end

  def answere_questions(test)
    @assessment_participation.answered_questions(test)
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

  private

  def determine_next_url
    if @assessment_participation.unanswered_tests.any?
      candidate_test_path(first_unanswered_test)
    else
      checkout_candidate_assessment_participation_path(@assessment_participation)
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

  def started?(test)
    participation_test = @assessment_participation.participation_tests.find_by(test:)
    participation_test.started_at.present? && participation_test.status == 'started'
  end
end
