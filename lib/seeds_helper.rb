module SeedsHelper
  class << self
    def create_multiple_choice_test!(title, attributes = {})
      MultipleChoiceTest.find_or_create_by!(title:) do |test|
        test.attributes = attributes
      end
    end
  end
end
