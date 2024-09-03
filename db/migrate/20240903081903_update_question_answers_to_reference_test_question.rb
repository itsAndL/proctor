class UpdateQuestionAnswersToReferenceTestQuestion < ActiveRecord::Migration[7.1]
  def up
    # Add the new column (initially allowing null)
    add_reference :question_answers, :test_question, foreign_key: true

    # Update existing records
    QuestionAnswer.find_each do |question_answer|
      test_question = TestQuestion.find_by(
        test_id: question_answer.test_id,
        question_id: question_answer.question_id
      )

      if test_question
        question_answer.update(test_question_id: test_question.id)
      else
        puts "Warning: No matching TestQuestion found for QuestionAnswer id: #{question_answer.id}"
      end
    end

    # Remove any QuestionAnswers that couldn't be associated with a TestQuestion
    QuestionAnswer.where(test_question_id: nil).destroy_all

    # Make test_question_id non-nullable
    change_column_null :question_answers, :test_question_id, false

    # Remove old index
    remove_index :question_answers, name: "index_question_answers_on_participation_question_and_test"

    # Add new unique index
    add_index :question_answers, [:assessment_participation_id, :test_question_id], unique: true, name: "index_question_answers_on_participation_and_test_question"

    # Remove old columns and their indexes
    remove_index :question_answers, :question_id
    remove_index :question_answers, :test_id
    remove_column :question_answers, :question_id
    remove_column :question_answers, :test_id
  end

  def down
    # Add back the old columns as nullable first
    add_reference :question_answers, :question, foreign_key: true
    add_reference :question_answers, :test, foreign_key: true

    # Remove new index
    remove_index :question_answers, name: "index_question_answers_on_participation_and_test_question"

    # Restore old index
    add_index :question_answers, [:assessment_participation_id, :question_id, :test_id], unique: true, name: "index_question_answers_on_participation_question_and_test"

    # Restore data from test_question association
    QuestionAnswer.find_each do |question_answer|
      if question_answer.test_question_id
        test_question = TestQuestion.find(question_answer.test_question_id)
        question_answer.update(
          question_id: test_question.question_id,
          test_id: test_question.test_id
        )
      end
    end

    # Now make the columns non-nullable
    change_column_null :question_answers, :question_id, false
    change_column_null :question_answers, :test_id, false

    # Remove the new column
    remove_reference :question_answers, :test_question
  end
end
