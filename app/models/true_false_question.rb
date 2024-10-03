class TrueFalseQuestion < Question
  validates :is_correct, inclusion: {
    in: [true, false],
    message: 'can only be set to true or false'
  }
end
