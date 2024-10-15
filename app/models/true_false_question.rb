class TrueFalseQuestion < Question
  validates :is_correct, inclusion: {
    in: [true, false],
    message: :inclusion
  }
end
