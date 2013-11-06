class ChangeBodyColumnsToText < ActiveRecord::Migration
  def up
    change_column :questions, :body, :text
    change_column :answers, :body, :text
    change_column :comments, :body, :text
    change_column :edit_suggestions, :body, :text
  end

  def down
    change_column :questions, :body, :string
    change_column :answers, :body, :string
    change_column :comments, :body, :string
    change_column :edit_suggestions, :body, :string
  end
end
