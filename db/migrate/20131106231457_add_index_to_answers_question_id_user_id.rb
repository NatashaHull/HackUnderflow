class AddIndexToAnswersQuestionIdUserId < ActiveRecord::Migration
  def up
    add_index :answers, [:question_id, :user_id], :unique => true
  end
end
