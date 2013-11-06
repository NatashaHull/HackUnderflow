class AddAcceptedColumnToAnswers < ActiveRecord::Migration
  def up
    add_column :answers, :accepted, :boolean, :default => false
  end
end
