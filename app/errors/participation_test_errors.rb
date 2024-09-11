module ParticipationTestErrors
  class TestNotFoundError < StandardError
    def initialize(msg = 'Test not found')
      super
    end
  end

  class QuestionNotFoundError < StandardError
    def initialize(test_id, question_id)
      super("Question not found for test ID: #{test_id} and question ID: #{question_id}")
    end
  end

  class NoCurrentQuestionError < StandardError
    def initialize
      super('Cannot save answer: No current question available')
    end
  end

  class TestQuestionNotFoundError < StandardError
    def initialize(test_id, question_id)
      super("TestQuestion not found for test ID: #{test_id} and question ID: #{question_id}")
    end
  end

  class InvalidTestSetupError < StandardError
    def initialize
      super('Invalid test setup: AssessmentTest not found')
    end
  end
end
