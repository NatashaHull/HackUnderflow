class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :title
      t.string :body
      t.integer :user_id

      t.timestamps
    end

    add_index :questions, :user_id
  end
end
