module ParticipationTestErrors
  class TestNotFoundError < StandardError
    def initialize(msg = 'Sorry, we could not find the test you are looking for.')
      super
    end
  end

  class QuestionNotFoundError < StandardError
    def initialize(msg = 'Sorry, we could not find the question you are looking for.')
      super
    end
  end

  class TestQuestionNotFoundError < StandardError
    def initialize(msg = 'Sorry, we could not find the test question you are looking for.')
      super
    end
  end
end
