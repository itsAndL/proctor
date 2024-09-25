# frozen_string_literal: true

class CandidateImportPreviewComponent < ViewComponent::Base
  def initialize
    @sample_candidates = [
      { name: 'John Doe', email: 'john.doe@example.com' },
      { name: 'Jame Smith', email: 'jame.smith@example.com' }
    ]
  end
end
