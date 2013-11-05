class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.string :body
      t.integer :question_id
      t.integer :user_id

      t.timestamps
    end

    add_index :answers, :question_id
    add_index :answers, :user_id
  end
end
